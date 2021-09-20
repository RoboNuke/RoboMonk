extends Control

#onready var parent = get_parent()



func _on_Level_Select_Button_pressed():
	get_tree().change_scene_to(Globals.level_select_scene)


func _on_Next_Level_Button_pressed():
	var level_name = Globals.levels[Globals.world][Globals.level]
	var world_name = Globals.worlds[Globals.world]
	var next_level = load("res://2. Levels/" + world_name + "/" + level_name + "/" + level_name + ".tscn")
	get_tree().change_scene_to(next_level)
