extends KinematicBody2D

onready var coyote_timer = $"Timers/Coyote Timer"
onready var jump_buffer = $"Timers/Jump Buffer"
onready var ground_rays = $"Ground Rays"
onready var animation_tree = $AnimationTree
onready var player_rig =  $"Charecter Rig"

# motion variables
var velocity = Vector2.ZERO
export var gravity = 1200
export var move_speed = 200
export var jump_force = 1200
export var modifier = 1
var FLOOR_NORMAL = Vector2.UP


# State Variables
var is_jumping = false
var is_grounded = false
var was_on_floor = false
var is_dashing = false
var anim_tree_state_machine = null
var look_left = false
# ANIMATION vars
export var left_shoulder = 5
export var right_shoulder = -5

func _ready():
	anim_tree_state_machine = animation_tree["parameters/playback"]
	
func _apply_movement():
	var snap: Vector2 = Vector2(0,25) if !is_jumping and !is_dashing else Vector2.ZERO
	
	was_on_floor = _check_if_grounded()
	#print(velocity)
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL, false, 4, deg2rad(60))
		
	# coyote timer stuff
	if not _check_if_grounded() and was_on_floor and not is_jumping and not is_dashing:
		coyote_timer.start()
		velocity.y = 0
	# jump buffer
	if _check_if_grounded() and !jump_buffer.is_stopped() and velocity.y == 0:
		#print("buffered jump")
		jump_buffer.stop()
		_jump()
	
	is_grounded = _check_if_grounded()
	#print(is_grounded, " && ", is_on_floor())

func restart(pos):
	position = pos
	velocity = Vector2.ZERO
	start_camera()
	
func stop_camera():
	$Camera2D.current = false
	
func start_camera():
	$Camera2D.current = true


func _dash():
	pass
	
func _apply_gravity(delta):
	if coyote_timer.is_stopped() and not is_dashing:
		velocity.y += gravity * delta * modifier
		if is_jumping && velocity.y > 0:
			is_jumping = false
	
func _check_if_grounded():
	for ray in ground_rays.get_children():
		ray.force_raycast_update()
		if ray.is_colliding():
			return true
	return false
	
func _jump():
	velocity.y -= jump_force
	is_jumping = true

var facing_direction = -1

func _handle_move_input():

	var move_direction = (-int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right")))
	
	if facing_direction != move_direction and move_direction != 0:
		transform *= Transform2D.FLIP_X
		facing_direction = move_direction
		
	if !is_dashing:
		velocity.x = lerp(velocity.x, move_direction * move_speed, _get_h_weight())
		
func _get_h_weight():
	if is_grounded or not coyote_timer.is_stopped():
		return .2
	else:
		return 0.1
	
var last_hit = null

func hit(hitter):
	#print("Player Hit")
#	if shield_holder.will_block():
#		#print("Blocked by shield")
#		last_hit = hitter
	if last_hit != hitter:
		print("You Lose")
		#queue_free()
