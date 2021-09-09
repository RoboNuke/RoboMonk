extends Node2D

onready var anim_player = $AnimationPlayer
onready var camera = $Camera2D
onready var rumble_timer = $"Rumble Timer"
onready var key_pts = $"Key Points"
onready var player_start = $"Player Start"
onready var far_pt = $"Farthest Point"
onready var parent = get_parent()

export(String) var dialog = "Game_Start"
var player

var audio_file = "res://2. Levels/1. The Chase/1.1 Underground Escape/Sound Effects/"
export var long_rumble = "lowFrequency_explosion_000.ogg"
export var short_rumble = "lowFrequency_explosion_001.ogg"
var total_rumbles = 2
var rumbles = 0
var fall_dist = 700

func player_death():
	print("Better luck next time")

func get_fall_dist():
	return fall_dist  

func dialog_complete():
	parent.add_player()
	rumble()

func init_level():
	parent.play_dialog(dialog)

func get_player_start():
	return player_start.global_position

func rumble():
	camera.add_trauma(4)
	AudioPlayer.play(audio_file + long_rumble)
	AudioPlayer.play(audio_file + short_rumble)
	rumbles += 1
	rumble_timer.start()
	

func _on_Rumble_Timer_timeout():
	if rumbles < total_rumbles:
		AudioPlayer.play(audio_file + short_rumble)
		rumbles += 1
		rumble_timer.start()
	else:
		rumbles = 0


func _on_Win_Area_body_entered(_body):
	print("You Win!")
