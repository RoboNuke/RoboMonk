extends Node2D

onready var parent = get_parent()
onready var head_sprite = find_node("Head Sprite")
onready var body_sprite = find_node("Body Sprite")
onready var state_machine = parent.find_node("State Machine")

var frame_angles = [0, 30, 60, 90]

func _process(delta):
	if parent.weapon.bullet_spawn.global_position.x - parent.global_position.x > 0:
		scale.x = abs(scale.x) # facing left?
	else:
		scale.x = -abs(scale.x) # facing right

	if true: #state_machine.state != state_machine.states.search:
		var shoulder_rotation = parent.weapon.rotation_degrees
		if shoulder_rotation > 0 or shoulder_rotation < -180:
			head_sprite.frame = 1
		else:
			shoulder_rotation *= -1 
			if shoulder_rotation > 90:
				shoulder_rotation = 180-shoulder_rotation 
			head_sprite.frame = find_closest(shoulder_rotation, frame_angles) + 1
		
const INT_MAX = 2147483647

func find_closest(num, array):
	var best_match = null
	var best_idx = null
	var least_diff = INT_MAX
	for i in range(len(array)):#number in array:
		var diff = abs(num - array[i])
		if(diff < least_diff):
			best_match = array[i]
			best_idx = i
			least_diff = diff
	return best_idx
