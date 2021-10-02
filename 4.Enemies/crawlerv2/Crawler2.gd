extends KinematicBody2D

onready var fov = find_node("FieldOfView")
onready var rof_timer = find_node("Rate Of Fire")
onready var weapon = find_node("Shoulder")
onready var body_player = find_node("Body Animation Player")
onready var head_player = find_node("Head Animation Player")

# game variables
var player = null
var CLOSEST_DISTANCE = 2
var SNAP = Vector2(0, 5)
var velocity = Vector2.ZERO
var speed = 100

# state variables
var in_warn_area = false
var in_danger_area = false
var move_direction = Globals.DIRS.NONE

func _physics_process(_delta):
	update_fov()
	update_move_direction()
	velocity = move_and_slide_with_snap(velocity, SNAP, Globals.FLOOR_NORMAL, false, 4, deg2rad(60))

func update_move_direction():
	if in_warn_area or in_danger_area:
		move_direction = Globals.DIRS.LEFT if global_position.x > player.global_position.x else Globals.DIRS.RIGHT
	else:
		move_direction = Globals.DIRS.NONE

func search():
	print("I'm Searching")
	
func chase():
	if abs(global_position.x - player.position.x) > CLOSEST_DISTANCE:
		velocity = move_direction * speed * Vector2.RIGHT
	else:
		velocity = Vector2(0,0)

func attack():
	if rof_timer.is_stopped():
		weapon.fire()
		rof_timer.start()
	
func update_fov():
	fov.check_view()
	in_danger_area = false
	for hit in fov.in_danger_area:
		if "Player" in hit.get_groups():
			player = hit
			in_danger_area = true
			
	in_warn_area = false
	for hit in fov.in_warn_area:
		if "Player" in hit.get_groups():
			player = hit
			in_warn_area = true
	#print (in_danger_area, " ", in_warn_area)

func can_attack():
	return rof_timer.is_stopped() and in_danger_area

func can_chase():
	return in_warn_area or in_danger_area
