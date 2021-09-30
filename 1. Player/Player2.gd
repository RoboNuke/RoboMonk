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
var IDLE_CUTOFF = 1.5
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
var wall_slide_gravity
var wall_jump_velocity
export var wall_slide_gravity_modifier = 10.0

# dash vars
var absorbed_momentum = 0
var has_dashed = false

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	wall_slide_gravity = gravity / wall_slide_gravity_modifier
	wall_jump_velocity = Vector2(0.5,.95) * max_jump_velocity
	print("Wall Jump Velocity: ", wall_jump_velocity)

func apply_gravity(delta):
	if dashing or absorbing:
		return 
	if is_on_wall() and is_falling():
		velocity.y += wall_slide_gravity * delta
	elif coyote_timer.is_stopped():
		velocity.y += gravity * delta
		if jumping and is_falling():
			jumping = false

func apply_movement():
	
	var was_on_floor = ground_rays.is_grounded()
	
	var snap: Vector2 = Vector2(0,5) if !jumping and !dashing and was_on_floor else Vector2.ZERO
	
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL, false, 4, deg2rad(60), false)
	
	# See if he has fallen below max_fall_dist
	check_has_fallen()
	
	grounded = ground_rays.is_grounded()
	# coyote timer stuff
	if not grounded and was_on_floor and not jumping:# and not dashing:
		coyote_timer.start()
		velocity.y = 0
	
	if has_dashed and grounded:
		reset_dash()
	
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

func wall_jump():
	jumping = true
	velocity = wall_jump_velocity
	velocity.x *= on_wall_side

func jump():
	coyote_timer.stop()
	jump_buffer_timer.stop()
	jumping = true
	velocity.y = max_jump_velocity

func can_jump():
	# checks if grounded or if we are still in the coyote_timer window
	return ground_rays.is_grounded() or !coyote_timer.is_stopped()

func apply_x_velocity():
	if !absorbing and !dashing:
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

func start_absorbing():
	absorb_timer.start()
	velocity = Vector2(0,0)
	absorbing = true
	absorbed_momentum = 0

func _absorb(collided_object):
	absorbed_momentum += collided_object.get_momentum()
	collided_object.absorbed()    

func _on_Maximum_Absorb_timeout():
	dash()
	
func dash():
	var dash_direction = Vector2.ZERO
	absorbing = false
	dashing = true
	absorb_timer.stop()
	dash_timer.start()
	dash_direction.x = (-int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right")))
	dash_direction.y = (-int(Input.is_action_pressed("ui_up")) + int(Input.is_action_pressed("ui_down")))
	
	velocity = dash_direction.normalized() * absorbed_momentum
	
func end_dash():
	has_dashed = true
	dashing = false

func reset_dash():
	has_dashed = false
	
func _on_Dash_Timer_timeout():
	end_dash()
	
# interface
func is_grounded():
	return grounded
	
func is_falling():
	return velocity.y > 0
	
func is_jumping():
	return jumping
	
func is_running():
	return abs(velocity.x) > IDLE_CUTOFF and move_direction != 0

func is_on_wall():
	return on_wall_side != 0 and !grounded
	
func is_absorbing():
	return absorbing
	
func is_dashing():
	return dashing
	
func can_absorb():
	return !has_dashed


func hit(hitter):
	if absorbing and "Absorbable" in hitter.get_groups():
		_absorb(hitter)
	elif "Deadly Floor" in hitter.get_groups():
		print("Hit deadly floor")
		emit_signal("player_killed")
	elif "Wall" in hitter.get_groups():
		return
	else:
		emit_signal("player_killed")

