extends Level

onready var rumble_timer = $"Rumble Timer"
onready var bg_music_player = find_node("Background Music")
export(String) var dialog = "Game_Start"

var audio_file = "res://2. Levels/1. The Chase/1-1 Underground Escape/Sound Effects/"
export var long_rumble = "lowFrequency_explosion_000.ogg"
export var short_rumble = "lowFrequency_explosion_001.ogg"
export var bg_music_file = "Ludum Dare 30 - Track 6.wav"

var total_rumbles = 2
var rumbles = 0
export var maximum_fall_distance = 700

func _ready():
	fall_dist = maximum_fall_distance
	player.visible = false
	dialog_player.play_dialog(dialog)
	Globals.call_deferred("pause_game")
	dialog_player.visible = true
	
func dialog_complete():
	Globals.unpause_game()
	#player.set_fall_dist(fall_dist) ###################################FIX LATER
	player.visible = true
	rumble()
	Globals.stop_bg_music()
	bg_music_player.volume_db = Globals.music_volume
	bg_music_player.play()

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
	player_win()

func _on_Dialog_Player_dialog_complete():
	dialog_complete()

func _on_Player_player_killed():
	player_death()
