extends Node2D

onready var dialog_player = $"Dialog Player"

export(bool) var DEBUG_LEVEL = false

# Packed Scenes
export(PackedScene) var start_menu_scene = preload("res://5. User Interfaces/Start Menu/Start Menu.tscn")#.instance()
export(PackedScene) var player_scene = preload("res://1. Player/Player.tscn")
#export(PackedScene) var prototype_level_scene = preload("res://2. Levels/Prototype Level/Prototype Level.tscn")
export(PackedScene) var working_level_scene = preload("res://2. Levels/1. The Chase/1.1 Underground Escape/1-1 Underground Escape.tscn")
var current_level
var player



func _ready():
	if DEBUG_LEVEL:
		_load_level()
	else:
		goto_main_menu()
	var file = File.new()
	file.open("res://2. Levels/Level Metadata.json", file.READ)
	var json = file.get_as_text()
	var jdata = parse_json(json)
	print(jdata)
	

func goto_main_menu():
	if current_level != null:
		remove_child(current_level)
		current_level.queue_free()
		remove_child(player)
		player.queue_free()
	
	current_level = start_menu_scene.instance()
	
	add_child(current_level)
	current_level.start_button.connect("pressed", self, "_on_Start_Button_pressed", [name])
	current_level.quit_button.connect("pressed", self, "_on_Quit_Button_pressed")
		

func _load_level(level=working_level_scene):
	if current_level != null:
		current_level.queue_free()
	current_level = level.instance()
	add_child(current_level)
	current_level.init_level()

func add_player():
	player = player_scene.instance()
	add_child(player) #################################
	player.restart(current_level.get_player_start(), current_level.get_fall_dist())
	player.connect("player_killed", self, "_on_player_death")
	current_level.player = player
	
func _on_Start_Button_pressed(_nam):
	if current_level != null:
		remove_child(current_level)
	_load_level()

func play_dialog(record_name : String):
	dialog_player.play_dialog(record_name)
	call_deferred("_pause_game")

func _pause_game():
	get_tree().paused = true

func _unpause_game():
	get_tree().paused = false

func _on_player_death():
	current_level.player_death()
	goto_main_menu()

func _on_Quit_Button_pressed():
	get_tree().quit()

func _on_Dialog_Player_dialog_complete():
	_unpause_game()
	current_level.dialog_complete()
	
