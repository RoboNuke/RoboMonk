extends Node


onready var key_pts = $"Key Points"
onready var player_start = $"Player Start"
onready var far_pt = $"Farthest Point"
onready var parent = get_parent()
var player 

func init_level():
	pass
	
func get_player_start():
	return Vector2.ZERO
	
func get_fall_dist():
	return -1000

func player_death():
	pass
	
func player_win():
	pass
	
