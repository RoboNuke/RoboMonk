extends Position2D


onready var parent = get_parent()
export(Vector2) var ball_location = Vector2(-20,-18)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	ball_location.x = -abs(ball_location.x) if parent.facing_dir == parent.FACE_DIRS.LEFT else abs(ball_location.x)
	#parent.beam_rays.position = beam_location
	position = ball_location
		
