extends Particles2D

onready var absorb_box = get_parent()#.find_node("Absorb Box")



func _process(delta):
	process_material.emission_box_extents.x = absorb_box.shape.extents.x
	process_material.emission_box_extents.y = absorb_box.shape.extents.y
	visible = !absorb_box.disabled
	
