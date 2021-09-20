extends Level

onready var right_moving_wall = find_node("Right Moving Wall")
onready var left_moving_wall = find_node("Left Moving Wall")
onready var wall_moving_timer = find_node("Wall Moving Timer")
onready var left_tween = find_node("Left Tween")
onready var right_tween = find_node("Right Tween")


export(int) var distance_walls_move = 50
export(float) var wall_move_time = 2

var left_counter = 0
var right_counter = 0

func _ready():
	wall_moving_timer.wait_time = wall_move_time


func _process(delta):
	if !left_tween.is_active():
		left_tween.interpolate_property(left_moving_wall, "position:x",
			  left_moving_wall.global_position.x, 
			  left_moving_wall.global_position.x - distance_walls_move * pow(-1,left_counter), 
			  wall_move_time,
			  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		left_tween.start()
		left_counter = (left_counter + 1) % 2
	if !right_tween.is_active():
		right_tween.interpolate_property(right_moving_wall, "position:x",
			  right_moving_wall.global_position.x, 
			  right_moving_wall.global_position.x + distance_walls_move * pow(-1,right_counter), 
			  wall_move_time,
			  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		right_tween.start()
		right_counter = (right_counter + 1) % 2
		
	

