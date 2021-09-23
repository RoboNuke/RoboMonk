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

var bg_music = null

func add_bg_music(song):
	bg_music = song

func player_death():
	print("Better luck next time")
	get_tree().change_scene_to(main_menu_scene)

func get_player_start():
	return player_start.global_position

func player_win():
	_update_level()
	get_tree().change_scene_to(Globals.win_level_screen)

func get_fall_dist():
	return fall_dist  

func dialog_complete():
	Globals.unpause_game()
	print("Dialog Completed")

func start_bg_music():
	if bg_music != null:
		AudioPlayer.play(bg_music)

func _update_level():
	if Globals.level + 1 == 5:
		Globals.world += 1
		Globals.level = 0
	else:
		Globals.level += 1
	Globals.unlock_level(Globals.world, Globals.level)
	
