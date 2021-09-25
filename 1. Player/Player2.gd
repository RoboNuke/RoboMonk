extends KinematicBody2D

onready var ground_rays = find_node("Ground Rays")



# constants
var FLOOR_NORMAL = Vector2.UP
enum DIRS {LEFT=-1, NONE=0, RIGHT=1}

# State Variables
var grounded = true
var on_wall_side = DIRS.NONE
var absorbing = false
var dashing = false
var jumping = false

# Motion Variables
var velocity = Vector2.ZERO
var move_direction = DIRS.NONE
var MOVE_SPEED = 9 * Globals.TILE_WIDTH
export var gravity = 100


func apply_gravity(delta):
	velocity.y += gravity * delta
	
func apply_movement():
	var snap: Vector2 = Vector2(0,25) if !jumping and !dashing else Vector2.ZERO
	
	var was_on_floor = ground_rays.is_grounded()
	
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL, false, 4, deg2rad(60))

	""""
	# coyote timer stuff
	if not grounded and was_on_floor and not jumping and not dashing:
		coyote_timer.start()
		velocity.y = 0
	# jump buffer
	if grounded and !jump_buffer.is_stopped() and velocity.y == 0:
		jump_buffer.stop()
		_jump()
	
	if max_fall_dist:
		if position.y > max_fall_dist:
			print("Fall Death: ", position.y)
			emit_signal("player_killed")
	"""

func apply_x_velocity():
	velocity.x = lerp(velocity.x, move_direction * MOVE_SPEED, _get_h_weight())

func jump():
	#parent.coyote_timer.stop()
	jumping = true
	velocity.y -= 100

# helpers
func can_jump():
	return ground_rays.is_grounded()# or !parent.coyote_timer.is_stopped():


func _get_h_weight():
	if grounded: # or not coyote_timer.is_stopped():
		return .2
	else:
		if move_direction == DIRS.NONE:
			return 0.02
		elif move_direction == sign(velocity.x) and abs(velocity.x) >  MOVE_SPEED:
			return 0.0
		else:
			return 0.1
