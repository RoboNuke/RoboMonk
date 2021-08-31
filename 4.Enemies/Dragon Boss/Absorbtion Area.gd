extends Area2D


onready var parent = get_parent()
onready var jaw_area = $"Jaw Area"


func _process(_delta):
	
	if parent.facing_dir == parent.FACE_DIRS.LEFT:
		jaw_area.position.x = -7.5
	else:
		jaw_area.position.x = 7.5
		
	#jaw_area.disabled = !parent.opening_jaw
	
