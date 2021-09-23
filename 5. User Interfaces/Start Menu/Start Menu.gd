extends Control

onready var start_button = $"ColorRect/NinePatchRect/VBoxContainer/CenterContainer/Start Button"
onready var quit_button = $"ColorRect/NinePatchRect/VBoxContainer/CenterContainer2/Quit Button"
onready var bg_music_player = find_node("Background Music Player")
onready var timer = find_node("Timer")



export(PackedScene) var level_select

export(AudioStream) var bg_music1 
export(AudioStream) var bg_music2
export(AudioStream) var bg_music3

func _ready():
	Globals.add_ui_music(bg_music1, bg_music2, bg_music3)
	Globals.start_bg_music()


func _on_Start_Button_pressed():
	get_tree().change_scene_to(level_select)



func _on_Quit_Button_pressed():
	get_tree().quit()

