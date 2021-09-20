extends Control

onready var g1_button = find_node("Game One Button")
onready var g2_button = find_node("Game Two Button")
onready var g3_button = find_node("Game Three Button")

onready var g1_label = find_node("Game One Label")
onready var g2_label = find_node("Game Two Label")
onready var g3_label = find_node("Game Three Label")

onready var select_label = find_node("Select Label")
onready var delete_label = find_node("Delete Label")

onready var select_button = find_node("Select Button")
onready var delete_button = find_node("Delete Button")

export(PackedScene) var level_select_scene
export(String) var save_data_path = "res://5. User Interfaces/Save Game Menu/Save Game Data/"

var data
var new_game_data
var buttons
var labels

var selected_idx

func _ready():
	buttons = [g1_button, g2_button, g3_button]
	labels = [g1_label, g2_label, g3_label]
	data = [null, null, null]
	for i in range(3):
		data[i] = _get_json_data(save_data_path + "g" +  str(i+1) + "_data.json")
		print(data[i][2])
		if data[i][2] == "":
			labels[i].text = "New\nGame"
		else:
			labels[i].text = data[i][2] + "'s\nGame"
	new_game_data = _get_json_data(save_data_path + "new_game_data.json")

func _get_json_data(filepath:String):
	var file = File.new()
	var error = file.open(filepath, file.READ)
	var json = file.get_as_text()
	file.close()
	return(parse_json(json))
	
func _write_json_data(filepath:String, data):
	var file = File.new()
	file.open(filepath, file.WRITE)
	file.store_line(to_json(data))
	file.close()
	
func _process(_delta):
	pass

func _set_global_data():
	Globals.player_name = data[selected_idx][2]
	Globals.levels = data[selected_idx][1]
	Globals.worlds = data[selected_idx][0]
	Globals.game_data_path = save_data_path + "g" +  str(selected_idx+1) + "_data.json"
	for i in range(5):
		for j in range(5):
			if Globals.levels[i][j][0] == "#":
				Globals.levels[i][j] = Globals.levels[i][j].right(1)
			else:
				Globals.unlocked[i][j] = true

func _button_toggled(button_pressed, idx):
	if button_pressed:
		selected_idx = idx
		for i in range(len(buttons)):
			if idx == i:
				continue
			else:
				buttons[i].pressed = false
		if data[idx][2] != "":
			select_label.text = "Continue"
			select_button.disabled = false
			delete_button.disabled = false
		else:
			select_label.text = "Start"
			select_button.disabled = false
			delete_button.disabled = false

func _on_Game_One_Button_toggled(button_pressed):
	_button_toggled(button_pressed, 0)

func _on_Game_Two_Button_toggled(button_pressed):
	_button_toggled(button_pressed, 1)

func _on_Game_Three_Button_toggled(button_pressed):
	_button_toggled(button_pressed, 2)


func _on_Select_Button_pressed():
	
	if data[selected_idx][2] != "":
		get_tree().change_scene_to(level_select_scene)
	else:
		get_node("LineEdit").visible = true
		get_node("LineEdit").grab_focus()
	_set_global_data()
	
func _on_Delete_Button_pressed():
	_write_json_data(save_data_path + "g" +  str(selected_idx+1) + "_data.json", new_game_data)
	_ready()

func _on_LineEdit_text_entered(new_text):
	data[selected_idx] = _get_json_data(save_data_path + "g" +  str(selected_idx+1) + "_data.json")
	data[selected_idx][2] = new_text
	_set_global_data()
	get_tree().change_scene_to(level_select_scene)
