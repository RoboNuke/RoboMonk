extends Node2D

onready var parent = get_parent()
onready var right_rays = find_node("Right Rays")
onready var left_rays = find_node("Left Rays")

func _check_rays(rays):
	for ray in rays:
		ray.force_raycast_update()
		if ray.is_colliding():
			#print(ray.get_collider().get_parent().get_velocity())
			return [true, ray.get_collider().get_parent().get_velocity()]
			
	return [false, Vector2.ZERO]
	
	
func _process(_delta):
	var left_collider = _check_rays(left_rays.get_children())
	var right_collider = _check_rays(right_rays.get_children())
	parent.on_wall_side = int(right_collider[0]) - int(left_collider[0])
	parent.velocity += left_collider[1] + right_collider[1]
