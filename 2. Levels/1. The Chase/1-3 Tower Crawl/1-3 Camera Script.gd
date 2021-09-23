extends Camera2D

onready var parent = get_parent()
var projectResolution = Vector2(640,360)

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
var max_y

var cam_pts = []
var y_diffs = []

func _ready():
	max_y = get_parent().get_node("Farthest Point").global_position.y + projectResolution.y/2
	
	randomize()

func _process(delta):
	if parent.player != null:
		global_position.y = min(parent.player.global_position.y - projectResolution.y/2, 0)
		
		if global_position.y > projectResolution.y:
			global_position.y = min(global_position.y, max_y)
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	
	
func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * rand_range(-1, 1)
	offset.x = max_offset.x * amount * rand_range(-1, 1)
	offset.y = max_offset.y * amount * rand_range(-1, 1)

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func _on_Camera2D_visibility_changed():
	projectResolution = get_viewport_rect().size
