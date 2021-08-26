extends Position2D


onready var parent = get_parent()
export(Vector2) var beam_location = Vector2(-20,-18)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	beam_location.x = -abs(beam_location.x) if parent.facing_dir == parent.FACE_DIRS.LEFT else abs(beam_location.x)
	#parent.beam_rays.position = beam_location
	position = beam_location
		
