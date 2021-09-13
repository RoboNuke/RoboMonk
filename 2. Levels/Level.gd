extends Node2D

onready var anim_player = $AnimationPlayer
onready var camera = $Camera2D
onready var key_pts = $"Key Points"
onready var player_start = $"Player Start"
onready var far_pt = $"Farthest Point"
onready var parent = get_parent()
onready var player = $Player
onready var dialog_player = $"Dialog Player"

var main_menu_scene = Globals.main_menu_scene
var fall_dist = 700


func player_death():
	print("Better luck next time")
	get_tree().change_scene_to(main_menu_scene)

func get_player_start():
	return player_start.global_position

func player_win():
	print("Good Job Maty")

func get_fall_dist():
	return fall_dist  

func dialog_complete():
	Globals.unpause_game()
	print("Dialog Completed")
