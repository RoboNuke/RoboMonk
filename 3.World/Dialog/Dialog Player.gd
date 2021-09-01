extends Node

onready var body_anim_player = find_node("Body_AnimationPlayer")
onready var body_label = find_node("Body Label")
onready var dialog_box = find_node("Dialog Box")
onready var left_label = find_node("Left Speaker Label")
onready var left_patch = find_node("Left Speaker NinePatchRect")
onready var right_label = find_node("Right Speaker Label")
onready var right_patch = find_node("Right Speaker NinePatchRect")
onready var space_icon = find_node("Space_NinePatchRect")
onready var left_portrait = find_node("Left Portrait")
onready var right_portrait = find_node("Right Portrait")

export(String) var portrait_name = "portraits"
var _did = 0
var _nid = 0
var _final_nid=0
var story_reader
var _texture_library : Dictionary = {}

signal dialog_complete
# Virtual
func _ready():
	var story_reader_class = load("res://addons/EXP-System-Dialog/Reference_StoryReader/EXP_StoryReader.gd")
	story_reader = story_reader_class.new()
	
	var story = load("res://3.World/Dialog/Stories/Story_V1 Baked.tres")
	
	story_reader.read(story)
	
	_load_textures()
	dialog_box.visible = false
	space_icon.visible = false
	left_patch.visible = false
	right_patch.visible = false
	#play_dialog("Game_Start")
	
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_SPACE and event.pressed == true:
			_on_Dialog_Player_pressed_spacebar()
	
# Callback Methods
func _on_Dialog_Player_pressed_spacebar():
	if _is_waiting():
		space_icon.visible = false
		_get_next_node()
		if _is_playing():
			_play_node()
			
func _on_AnimationPlayer_animation_finished(_anim_name):
	space_icon.visible = true

# Public Functions
func play_dialog(record_name : String):
	_did = story_reader.get_did_via_record_name(record_name)
	_nid = story_reader.get_nid_via_exact_text(_did, "<start>")
	_final_nid = story_reader.get_nid_via_exact_text(_did, "<end>")
	_get_next_node()
	_play_node()
	dialog_box.visible = true
	
# Private Functions
func _is_playing() -> bool:
	return dialog_box.visible
	
func _is_waiting() -> bool:
	return space_icon.visible
	
func _get_next_node():
	_nid = story_reader.get_nid_from_slot(_did, _nid, 0)
	left_patch.visible = false
	right_patch.visible = false
	right_portrait.visible = false
	left_portrait.visible = false
	if _nid == _final_nid:
		dialog_box.visible = false
		get_tree().paused = false
		emit_signal("dialog_complete")
		
func _get_tagged_text(tag : String, text : String) -> String:
	var start_tag = "<" + tag + ">"
	var end_tag = "</" + tag + ">"
	var start_index = text.find(start_tag) + start_tag.length()
	var end_index = text.find(end_tag)
	var substr_length = end_index - start_index
	return text.substr(start_index, substr_length)
	
func _play_node():
	var text = story_reader.get_text(_did, _nid)
	var dialog = _get_tagged_text("dialog", text)
	if "<left_image>" in text:
		var library_key = _get_tagged_text("left_image",text)
		_display_left_image(library_key) 
	if "<right_image>" in text:
		var library_key = _get_tagged_text("right_image",text)
		_display_right_image(library_key) 
	if "<left_speaker>" in text:
		print("left speaker")
		var speaker = _get_tagged_text("left_speaker", text)
		_display_left_speaker(speaker)
	if "<right_speaker>" in text:
		print("right speaker")
		var speaker = _get_tagged_text("right_speaker", text)
		_display_right_speaker(speaker)
	body_label.text = dialog
	body_anim_player.play("Text Display")

func _display_left_speaker(speaker : String):
	left_label.text = speaker
	left_patch.visible = true
	
func _display_right_speaker(speaker : String):
	right_label.text = speaker
	right_patch.visible = true
	
func _display_left_image(key : String):
	left_portrait.texture = _texture_library[key]
	left_portrait.visible = true
	right_portrait.visible = false
	#right_speaker.visable = false
	#left_speaker.visable = true

func _display_right_image(key : String):
	right_portrait.texture = _texture_library[key]
	right_portrait.visible = true
	left_portrait.visible = false
	

func _load_textures():
	print(story_reader.get_dids())
	var did = story_reader.get_did_via_record_name(portrait_name)
	var json_text = story_reader.get_text(did, 1)
	var raw_texture_library : Dictionary = parse_json(json_text)
	
	for key in raw_texture_library:
		var texture_path = raw_texture_library[key]
		var loaded_texture = load(texture_path)
		_texture_library[key] = loaded_texture
