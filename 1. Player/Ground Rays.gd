extends Node2D

onready var rays = get_children()
onready var parent = get_parent()


func is_grounded():
	for ray in rays:
		ray.force_raycast_update()
		if ray.is_colliding():
			parent.grounded = true
			print("Grounded")
			return true
	parent.grounded = false
	return false
			
