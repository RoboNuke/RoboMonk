extends Node2D

onready var parent = get_parent()
onready var head_sprite = find_node("Head Sprite")
onready var body_sprite = find_node("Body Sprite")

func _process(delta):
	if parent.move_direction == Globals.DIRS.LEFT:
		head_sprite.flip_h = false
		body_sprite.flip_h = false
	else:
		head_sprite.flip_h = true
		body_sprite.flip_h = true
		
		
