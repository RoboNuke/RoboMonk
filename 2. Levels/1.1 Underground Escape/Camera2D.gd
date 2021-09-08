extends Camera2D

onready var parent = get_parent()
var projectResolution = Vector2(640,360)

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].


var cam_pts = []
var y_diffs = []

func _ready():
	print("Screen Size: ", projectResolution.x)
	print("Screen Size: ", projectResolution.y)
	randomize()
	call_deferred("_cam_setup")

func _cam_setup():
	y_diffs = [0]
	var pts = parent.key_pts.get_children()
	pts.pop_front() # removes the player start pt
	for i in range(len(pts)-1):
		y_diffs.push_back(pts[i+1].global_position.y - pts[i].global_position.y)
		cam_pts.push_back(pts[i].global_position.x)
	y_diffs.push_back(0)
	cam_pts.push_back(pts[len(pts)-1].global_position.x)
	print("Y_diffs:", y_diffs)
	print("Cam_Pts:", cam_pts)

func _is_player_x_between(pt1, pt2):
	return (parent.player.global_position.x > pt1 and parent.player.global_position.x < pt2)
		
func _get_cam_region():
	if parent.player.global_position.x < cam_pts[0]:
		return 0
	for i in range(1,len(cam_pts)):
		if _is_player_x_between(cam_pts[i-1], cam_pts[i]):
			return i
	return len(cam_pts)

func _get_x_diff(region):
	if region >= len(cam_pts)-1:
		return 1
	return cam_pts[region+1] - cam_pts[region]
	
func _process(delta):
	if parent.player != null:
		global_position.x = max(parent.player.global_position.x - projectResolution.x/2, 0)
		var region = _get_cam_region()
		print("Region: ", region)
		var y_pt = 0
		for i in range(region): # add all previous y_diffs
			y_pt += y_diffs[i]
		print("Offset: ", y_pt)
		if y_diffs[region] != 0:
			y_pt += y_diffs[region] * (parent.player.global_position.x - cam_pts[region-1])/_get_x_diff(region-1)
			print("Real: ",  y_diffs[region] * (parent.player.global_position.x - cam_pts[region-1])/_get_x_diff(region))
		print("Final:", y_pt)
		global_position.y = y_pt
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
