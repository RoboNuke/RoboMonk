extends Node2D

onready var anim_player = $AnimationPlayer
onready var camera = $Camera2D
onready var rumble_timer = $"Rumble Timer"
onready var key_pts = $"Key Points"
onready var player_start = $"Player Start"
onready var far_pt = $"Farthest Point"
onready var parent = get_parent()
onready var player = $Player
onready var dialog_player = $"Dialog Player"
export(String) var dialog = "Game_Start"

var audio_file = "res://2. Levels/1. The Chase/1-1 Underground Escape/Sound Effects/"
export var long_rumble = "lowFrequency_explosion_000.ogg"
export var short_rumble = "lowFrequency_explosion_001.ogg"
export(PackedScene) var main_menu_scene = preload("res://5. User Interfaces/Start Menu/Start Menu.tscn")
var total_rumbles = 2
var rumbles = 0
var fall_dist = 700
func player_death():
	print("Better luck next time")

func get_fall_dist():
	return fall_dist  

func dialog_complete():
	player.set_fall_dist(fall_dist)
	player.visible = true
	rumble()

func _ready():
	player.visible = false
	dialog_player.play_dialog(dialog)
	call_deferred("pause_game")
	dialog_player.visible = true

func pause_game():
	get_tree().paused = true
	
func unpause_game():
	get_tree().paused = false

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


func _on_Dialog_Player_dialog_complete():
	unpause_game()
	dialog_complete()


func _on_Player_player_killed():
	player_death()
	get_tree().change_scene_to(main_menu_scene)
