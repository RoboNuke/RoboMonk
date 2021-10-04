extends Sprite

onready var parent = get_parent()

func _process(delta):
	frame = 11 - parent.height
	scale.x = sign(parent.facing_dir) * abs(scale.x)
	
