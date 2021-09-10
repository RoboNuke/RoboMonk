extends Control

onready var start_button = $"ColorRect/NinePatchRect/VBoxContainer/CenterContainer/Start Button"
onready var quit_button = $"ColorRect/NinePatchRect/VBoxContainer/CenterContainer2/Quit Button"

export(PackedScene) var level_select


func _on_Start_Button_pressed():
	get_tree().change_scene_to(level_select)



func _on_Quit_Button_pressed():
	get_tree().quit()
