extends Node2D

onready var left_tween = find_node("Left Tween")
var velocity = Vector2.ZERO

export(int) var distance_walls_move = 50.0
export(float) var wall_move_time = 2.0

var left_counter = 0
func _process(delta):
	if !left_tween.is_active():
		left_tween.interpolate_property(self, "position:x",
			  global_position.x, 
			  global_position.x - distance_walls_move * pow(-1,left_counter), 
			  wall_move_time,
			  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		left_tween.start()
		left_counter = (left_counter + 1) % 2

func get_velocity():
	return Vector2(distance_walls_move/(wall_move_time) * pow(-1,left_counter) - 5.75 * pow(-1,left_counter), 0)
