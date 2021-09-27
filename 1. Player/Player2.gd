extends KinematicBody2D

onready var ground_rays = find_node("Ground Rays")
onready var wall_rays = find_node("Wall Rays")
onready var coyote_timer = find_node("Coyote Timer")
onready var jump_buffer_timer = find_node("Jump Buffer")
onready var absorb_timer = find_node("Maximum Absorb")
onready var dash_timer = find_node("Dash Timer")
onready var label = find_node("Label")

# constants
var FLOOR_NORMAL = Vector2.UP
enum DIRS {LEFT=-1, NONE=0, RIGHT=1}
var max_fall_dist = 1000

#signal vars
signal player_killed

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


# Jump Parameters
var gravity = 100
var max_jump_velocity
var min_jump_velocity
var max_jump_height = 3.5 * Globals.TILE_WIDTH
var min_jump_height = 0.8 * Globals.TILE_WIDTH
var jump_duration = .3


func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	#WALL_JUMP_FORCE = Vector2(.5,.95) * max_jump_velocity

func apply_gravity(delta):
	if coyote_timer.is_stopped():
		velocity.y += gravity * delta
		if jumping and velocity.y > 0:
			print("Jump to false")
			jumping = false
	
func apply_movement():
	
	var was_on_floor = ground_rays.is_grounded()
	
	var snap: Vector2 = Vector2(0,5) if !jumping and !dashing and was_on_floor else Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL, false, 4, deg2rad(60))
	
	# See if he has fallen below max_fall_dist
	check_has_fallen()
	
	grounded = ground_rays.is_grounded()
	# coyote timer stuff
	if not grounded and was_on_floor and not jumping:# and not dashing:
		coyote_timer.start()
		velocity.y = 0
	
	# checks if the jump_buffer window was pressed and jumps if met
	if grounded and !jump_buffer_timer.is_stopped() and velocity.y == 0:
		jump_buffer_timer.stop()
		jump()
	
func set_fall_dist(fall_dist):
	max_fall_dist = fall_dist
	
func check_has_fallen():
	if global_position.y > max_fall_dist:
		print("Emit Player Killed")
		emit_signal("player_killed")

func tried_to_jump():
	jump_buffer_timer.start()

func release_jump():
	if velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity

func jump():
	coyote_timer.stop()
	jump_buffer_timer.stop()
	jumping = true
	velocity.y = max_jump_velocity

func can_jump():
	# checks if grounded or if we are still in the coyote_timer window
	return ground_rays.is_grounded() or !coyote_timer.is_stopped()

func apply_x_velocity():
	velocity.x = lerp(velocity.x, move_direction * MOVE_SPEED, _get_h_weight())

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
