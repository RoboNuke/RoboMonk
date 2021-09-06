extends Camera2D

onready var parent = get_parent()
var projectResolution = Vector2(640,360)

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].


var x_diff
var y_diff
var y_min
var y_max


func _ready():
	print("Screen Size: ", projectResolution.x)
	print("Screen Size: ", projectResolution.y)
	randomize()
	
func _update_y_shift_params():
	x_diff = parent.y_shift_end.global_position.x - parent.y_shift_start.global_position.x
	y_diff = parent.y_shift_end.global_position.y - parent.y_shift_start.global_position.y
	y_max = -parent.y_shift_end.global_position.y
	
func _process(delta):
	if parent.player != null:
		global_position.x = max(parent.player.global_position.x - projectResolution.x/2, 0)
		if parent.player.global_position.x > parent.y_shift_start.global_position.x and parent.player.global_position.x < parent.y_shift_end.global_position.x:
			_update_y_shift_params()
			# Scale Y of camera proportionate to how close to y_shift_end
			global_position.y = ((parent.player.global_position.x - parent.y_shift_start.global_position.x)/ x_diff) * y_diff
		if parent.player.global_position.x > parent.y_shift_end.global_position.x:
			_update_y_shift_params()
			global_position.y = y_max

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
