extends Camera2D

onready var parent = get_parent()
onready var top_pt = $"Top Point"
onready var bot_pt = $"Bottom Pt"

var projectResolution = Vector2(640,360)

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
var max_x 
var boss_mode = false

func _ready():
	randomize()
	call_deferred("_cam_setup")

func _cam_setup():
	max_x = parent.far_pt.global_position.x - projectResolution.x
	
func _process(delta):
	if boss_mode:
		var y = parent.player.global_position.y - projectResolution.y/2
		y = min(0, y)
		y = max(y, top_pt.global_position.y)
		global_position.y = y
	else:
		if parent.player != null:
			global_position.x = parent.player.global_position.x - projectResolution.x/2
			#global_position.x = min(global_position.x, max_x)
		
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

func start_boss_camera():
	global_position.x = top_pt.global_position.x
	boss_mode = true


func _on_Camera2D_visibility_changed():
	projectResolution = get_viewport_rect().size
