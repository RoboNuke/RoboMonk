extends Control

onready var title_label = $"ColorRect/NinePatchRect/VBoxContainer/Control2/Title Label"

export (PackedScene) var base_button
export (int) var total_levels = 25
export (NodePath) var grid

var levels
var worlds
func _ready():
	grid = get_node(grid)
	levels = Globals.levels
	worlds = Globals.worlds
	
	title_label.text = Globals.player_name + "'s " + title_label.text
	#if !total_levels <= 4:
	#	column_size()
	
	grid.columns = 5
	
	for i in range(1):
		for j in range(5):
			generate_buttons(worlds[i], levels[i][j], !Globals.unlocked[i][j])


func generate_buttons(world : String, name : String, disabled = false):
	var bb = base_button.instance()
	bb.set_world(world)
	bb.set_level(name)
	bb.disabled = disabled
	grid.add_child(bb)


func column_size():
	if total_levels % 2 == 0:
		grid.columns = total_levels/2
	else:
		grid.columns = total_levels/2 + 1

func _on_Back_Button_pressed():
	get_tree().change_scene_to(Globals.save_menu_scene)
	

func _on_Exit_Button_pressed():
	get_tree().quit()
