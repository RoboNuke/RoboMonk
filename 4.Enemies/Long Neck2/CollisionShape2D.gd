extends CollisionShape2D

onready var parent = get_parent()
# height = 0 -> y = -8.75/e=-8.75
# height = 11 -> y = -16/e = -16
func _process(delta):
	position.y = -8.75 - float(parent.height)/11.0 * 7.25
	shape.extents.y = abs(position.y)
