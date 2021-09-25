extends Node2D

onready var parent = get_parent()
onready var right_rays = find_node("Right Rays")
onready var left_rays = find_node("Left Rays")

func _check_rays(rays):
	for ray in rays:
		ray.force_raycast_update()
		if ray.is_colliding():
			return true
	return false
	
	
func _process(_delta):
	parent.on_wall_side = int(_check_rays(right_rays.get_children())) - int(_check_rays(left_rays.get_children()))
	if parent.on_wall_side == parent.DIRS.LEFT:
		print("Wall on left!")
	if parent.on_wall_side == parent.DIRS.RIGHT:
		print("Wall on right!")
