extends Node2D

onready var anim_player = $AnimationPlayer
onready var camera = $Camera2D
onready var rumble_timer = $"Rumble Timer"

onready var y_shift_start = $"Y-Shift Start"
onready var y_shift_end = $"Y-Shift End"


var player

var audio_file = "res://2. Levels/1.1 Underground Escape/Sound Effects/"
export var long_rumble = "lowFrequency_explosion_000.ogg"
export var short_rumble = "lowFrequency_explosion_001.ogg"
var total_rumbles = 2
var rumbles = 0
func get_player_start():
	return $"Player Start".global_position

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
