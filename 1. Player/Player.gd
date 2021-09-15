extends KinematicBody2D

onready var coyote_timer = $"Timers/Coyote Timer"
onready var jump_buffer = $"Timers/Jump Buffer"
onready var max_absorb = $"Timers/Max Absorb"
onready var dash_timer = $"Timers/Dash Timer"
onready var ground_rays = $"Ground Rays"
onready var animation_tree = $AnimationTree
onready var player_rig =  $"Charecter Rig"
onready var left_rays = $"Wall Rays/Left Rays"
onready var right_rays = $"Wall Rays/Right Rays"

# motion variables
var velocity = Vector2.ZERO
var FLOOR_NORMAL = Vector2.UP
var move_speed = 9 * Globals.TILE_WIDTH
var max_jump_velocity
var min_jump_velocity
var max_jump_height = 3.5 * Globals.TILE_WIDTH
var min_jump_height = .8 * Globals.TILE_WIDTH
var jump_duration = .3

var gravity
export var modifier = 1

export(Vector2) var WALL_JUMP_FORCE
export var WALL_SLIDE_MAX_VELOCITY = 50
export var WALL_SLIDE_DOWN_MAX_VELOCITY = 4800
export var starting_face_dir = -1

# absorbtion/dash variables
export var max_absorbtion = 2000
#var dash_strength = 600
var dash_direction = Vector2.ZERO
var absorbed_momentum = 0
# State Variables
var is_jumping = false
var is_grounded = false
var was_on_floor = false
var is_dashing = false
var has_dashed = false ####################################
var anim_tree_state_machine = null
var move_direction = 0
var wall_direction = 0
var desired_look_direction = 0
var facing_direction = -1
var is_absorbing = false
var max_fall_dist

#signal vars
signal player_killed

func _ready():
	desired_look_direction = starting_face_dir
	anim_tree_state_machine = animation_tree["parameters/playback"]
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	WALL_JUMP_FORCE = Vector2(1,-1) * max_jump_velocity * 2
	
func _apply_movement():
	var snap: Vector2 = Vector2(0,25) if !is_jumping and !is_dashing else Vector2.ZERO
	
	was_on_floor = _check_if_grounded()
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL, false, 4, deg2rad(60))

	# coyote timer stuff
	if not _check_if_grounded() and was_on_floor and not is_jumping and not is_dashing:
		coyote_timer.start()
		velocity.y = 0
	# jump buffer
	if _check_if_grounded() and !jump_buffer.is_stopped() and velocity.y == 0:
		jump_buffer.stop()
		_jump()
	
	is_grounded = _check_if_grounded()
	if max_fall_dist:
		if position.y > max_fall_dist:
			print("Fall Death: ", position.y)
			emit_signal("player_killed")
	
func restart(pos, fall_dist):
	position = pos
	velocity = Vector2.ZERO
	max_fall_dist = fall_dist

func set_fall_dist(fall_dist):
	max_fall_dist = fall_dist
	
func norm(x):
	if abs(x) < 1:
		return 0
	elif x > 0:
		return 1
	else:
		return -1
	
func _update_wall_direction():
	var is_near_wall_left = _check_is_valid_wall(left_rays.get_children())
	var is_near_wall_right = _check_is_valid_wall(right_rays.get_children())
	
	if is_near_wall_left and is_near_wall_right:
		wall_direction = move_direction
	else:
		wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)
	
func _check_is_valid_wall(rays):
	for ray in rays:
		if ray.is_colliding():
			var dot = acos(Vector2.UP.dot(ray.get_collision_normal()))
			if dot > PI * 0.35 and dot < PI * .55:
				return true
	return false
	
func _apply_gravity(delta):
	if coyote_timer.is_stopped() and not is_dashing and not is_absorbing:
		velocity.y += gravity * delta * modifier
		if is_jumping && velocity.y > 0:
			is_jumping = false
	
func _cap_gravity_wall_sliding():
	var max_velocity = WALL_SLIDE_MAX_VELOCITY if !Input.is_action_pressed("ui_down") else WALL_SLIDE_DOWN_MAX_VELOCITY
	velocity.y = min(max_velocity, velocity.y)
	
func _check_if_grounded():
	for ray in ground_rays.get_children():
		ray.force_raycast_update()
		if ray.is_colliding():
			return true
	return false
	
func _jump(wall_jump = false):
	if !wall_jump:
		velocity.y = max_jump_velocity
	else:
		velocity = WALL_JUMP_FORCE
		if sign(velocity.x) != facing_direction:
			velocity.x *= -1
			
	is_jumping = true 
	
func _face_desired_direction():
	if desired_look_direction !=  0 and desired_look_direction != facing_direction:
		transform *= Transform2D.FLIP_X
		var holder = left_rays
		left_rays = right_rays
		right_rays = holder
		facing_direction = desired_look_direction
	
func _update_move_direction():
	move_direction = (-int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right")))
	
func _handle_move_input():
	if !is_dashing and !is_absorbing:
		velocity.x = lerp(velocity.x, move_direction * move_speed, _get_h_weight())
		desired_look_direction = move_direction
		
	
func _get_h_weight():
	if is_grounded or not coyote_timer.is_stopped():
		return .2
	else:
		if move_direction == 0:
			return 0.02
		elif move_direction == sign(velocity.x) and abs(velocity.x) >  move_speed:
			return 0.0
		else:
			return 0.1
	
func _start_absorb():
	max_absorb.start()
	velocity = Vector2(0,0)
	is_absorbing = true
	absorbed_momentum = 0
	
func _absorb(collided_object):
	absorbed_momentum += collided_object.get_momentum()
	collided_object.absorbed()    
	
func _dash():
	is_absorbing = false
	is_dashing = true
	max_absorb.stop()
	dash_timer.start()
	dash_direction.x = (-int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right")))
	dash_direction.y = (-int(Input.is_action_pressed("ui_up")) + int(Input.is_action_pressed("ui_down")))
	
	velocity = dash_direction.normalized() * absorbed_momentum
	desired_look_direction = dash_direction.x
	
func _end_dash():
	has_dashed = true
	is_dashing = false
	
func hit(hitter):
	if is_absorbing and "Absorbable" in hitter.get_groups():
		_absorb(hitter)
	elif "Deadly Floor" in hitter.get_groups():
		print("Hit deadly floor")
		emit_signal("player_killed")
	elif "Wall" in hitter.get_groups():
		return
	else:
		emit_signal("player_killed")
	
func _on_Dash_Timer_timeout():
	_end_dash()
