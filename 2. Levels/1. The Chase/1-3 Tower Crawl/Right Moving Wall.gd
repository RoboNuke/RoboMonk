extends Node2D

onready var right_tween = find_node("Right Tween")
var velocity = Vector2.ZERO

export(int) var distance_walls_move = 50
export(float) var wall_move_time = 2

var right_counter = 0

func _process(delta):
	if !right_tween.is_active():
		right_tween.interpolate_property(self, "position:x",
			  global_position.x, 
			  global_position.x + distance_walls_move * pow(-1,right_counter), 
			  wall_move_time,
			  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		right_tween.start()
		right_counter = (right_counter + 1) % 2


func get_velocity():
	return Vector2(distance_walls_move/(wall_move_time) * pow(-1,right_counter) - 5 * pow(-1,right_counter), 0)
