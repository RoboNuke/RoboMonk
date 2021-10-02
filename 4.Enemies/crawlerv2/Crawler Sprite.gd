extends Node2D

onready var parent = get_parent()
onready var head_sprite = find_node("Head Sprite")
onready var body_sprite = find_node("Body Sprite")

func _process(delta):
	if parent.weapon.bullet_spawn.global_position.x - parent.global_position.x > 0:
		scale.x = abs(scale.x)
	else:
		scale.x = -abs(scale.x)
	
	#if parent.move_direction == Globals.DIRS.LEFT:
	#	scale.x = -abs(scale.x)
	#else:
	#	scale.x = abs(scale.x)
		
		
