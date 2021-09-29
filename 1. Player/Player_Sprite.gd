extends Sprite

onready var parent = get_parent()

func _process(delta):
	if parent.is_on_wall():
		if parent.move_direction == parent.DIRS.LEFT:
			flip_h = true
		elif parent.move_direction == parent.DIRS.RIGHT:
			flip_h = false
	else:
		if parent.move_direction == parent.DIRS.LEFT:
			flip_h = false
		elif parent.move_direction == parent.DIRS.RIGHT:
			flip_h = true
		
	
