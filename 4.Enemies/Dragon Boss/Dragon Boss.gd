extends KinematicBody2D

onready var bot_sprite = $"Bottom Sprite"
onready var top_sprite = $"Top Sprite"
onready var bot_player = $"Bottom Player"
onready var top_player = $"Top Player"
onready var tween = $"Tween"
onready var laser_sm = $"Laser Only State Machine"
onready var beam_cd = $"Beam CD"
onready var ball_cd = $"Ball CD"
onready var beam_rof = $"Beam ROF"
onready var ball_rof = $"Ball ROF"
onready var beam_rays = $"Beam Spawn/Beam Rays"
onready var beam_spawn = $"Beam Spawn"
onready var ball_spawn = $"Ball Spawn"
var player

enum FACE_DIRS {LEFT=0, RIGHT=1}
enum PHASES {INIT=0, FINAL=1}
enum MOVE_DIRS {UP=1, DOWN=-1, NONE=0}
enum ACTION_TRIGGERS {SWITCH_RIGHT=0, SWITCH_LEFT=1, DESTROY_BATTERY=2}

var velocity = Vector2.ZERO

# beam vars
var beam = preload("res://4.Enemies/Beam/Beam.tscn")
export(Texture) var beam_texture 
export var beam_speed = 100.0
export var beam_momentum = 200
export var max_beam_length = 15
export(Vector2) var BEAM_OFFSET = Vector2(10,30)
var beams_fired = 0

#ball vars
var ball = preload("res://4.Enemies/Ball/Ball.tscn")
export var ball_speed = 100
export var ball_momentum = 200
export var total_balls = 3
var balls_fired = 0

#state vars
var facing_dir = FACE_DIRS.LEFT
var desired_facing_dir = FACE_DIRS.LEFT
var firing = false
var firing_balls = false
var move_dir = MOVE_DIRS.UP
var opening_jaw = false
var phase = PHASES.INIT
export(Vector2) var speed = Vector2(600,75)
export var muzzle_offset = 20
var left_x 
var right_x

#battery vars/map destroy
export var batters_before_destroy = 3
export var total_batteries = 4
export var ping_pong_delta = 400
var destoryed_batteries = 0
export var beam_width = 5.0
var destroying_map = false
var map_destroyed = false
var shutdown = false
signal destroy_map
var rng = RandomNumberGenerator.new()
var restart_pos
func _ready():
	rng.randomize()

func start(pos):
	global_position = pos
	laser_sm.start()
	
func set_boss_data(data):
	left_x = data[0]
	right_x = data[1]
	beam_rof.set_wait_time(beam_width/beam_speed)
	
func _process(_delta):
	if firing and beams_fired >= max_beam_length:
		firing = false
		beams_fired = 0
		beam_cd.start()
	velocity.y = speed.y * move_dir
	velocity = move_and_slide(velocity)
	if destoryed_batteries == batters_before_destroy:
		destroying_map = true
	

func trigger_action(action):
	if action == ACTION_TRIGGERS.SWITCH_RIGHT:
		desired_facing_dir = FACE_DIRS.LEFT
	elif action == ACTION_TRIGGERS.SWITCH_LEFT:
		desired_facing_dir = FACE_DIRS.RIGHT
	elif action == ACTION_TRIGGERS.DESTROY_BATTERY:
		destroy_battery()

# this could be used to go up/down on a fixed track
var counter = 1
func _ping_pong_above():
	move_dir = MOVE_DIRS.NONE
	if !tween.is_active():
		#position.y += 200 * -1 ^ counter
		tween.interpolate_property(self, "position:x",
		  position.x, position.x + ping_pong_delta * pow(-1,counter), 10,
		  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		counter = (counter + 1)%2
		desired_facing_dir = FACE_DIRS.RIGHT if counter == 1 else FACE_DIRS.LEFT
		if desired_facing_dir == FACE_DIRS.LEFT:
			facing_dir = FACE_DIRS.LEFT
			top_sprite.flip_h= false
			bot_sprite.flip_h = false
		else:
			facing_dir = FACE_DIRS.RIGHT
			top_sprite.flip_h = true
			bot_sprite.flip_h = true
func _track_player():
	if abs(player.global_position.y - global_position.y + muzzle_offset) < 5:
		move_dir = MOVE_DIRS.NONE 
	elif player.global_position.y + muzzle_offset > global_position.y:
		move_dir = MOVE_DIRS.UP
	else:
		move_dir = MOVE_DIRS.DOWN

func _on_Beam_ROF_timeout():
	if firing:
		_fire_laser()

func _fire_laser():
	if beam_rof.is_stopped():
		#print("Fire")
		move_dir = MOVE_DIRS.NONE
		var b = beam.instance()
		b.set("beam_texture", beam_texture)
		b.set("velocity", beam_speed)
		b.set("momentum", beam_momentum)
		get_tree().root.add_child(b)
		
		var dir_vec = Vector2.LEFT if facing_dir == FACE_DIRS.LEFT else Vector2.RIGHT
		var beam_loc = get_beam_loc(b)
		b.release(beam_spawn.global_position, dir_vec, beam_loc) 
		beams_fired += 1
		beam_rof.start()

func _on_Ball_ROF_timeout():
	if balls_fired == total_balls:
		bot_player.play_backwards("low_gun")
		ball_cd.start()
		balls_fired = 0
		return
	if firing_balls:
		#_fire_ball()
		bot_player.play("low_fire")

func set_firing_balls():
	firing_balls = true
	
var angles = [45.0/2.0,45.0,45.0+45/2.0]
func _fire_ball():
	if ball_cd.is_stopped():
		ball_cd.start()
	if ball_rof.is_stopped():
		for ang in angles:
			var b = ball.instance()
		
			b.set('velocity', ball_speed)
			b.set("momentum", beam_momentum)
			get_tree().root.add_child(b)
			# get random direction on on side we facing
			var angle = deg2rad(rng.randf_range(20,70))
		#var angle = deg2rad(45)
		
			#angle = -angle if facing_dir == FACE_DIRS.RIGHT else angle
			ang = -ang if facing_dir==FACE_DIRS.RIGHT else ang
			var dir = Vector2.UP.rotated(deg2rad(ang)).normalized()
			dir = -dir #if facing_dir == FACE_DIRS.LEFT else dir
		
			b.release(ball_spawn.global_position, dir)
		balls_fired += 1
		ball_rof.start()

func get_beam_loc(b):
		if beams_fired == 0:
			return(b.BEAM_LOCS.RIGHT_END)
		elif beams_fired == max_beam_length - 1:
			return(b.BEAM_LOCS.LEFT_END )
		else:
			return(b.BEAM_LOCS.MIDDLE)

func _change_side():
	if desired_facing_dir == facing_dir:
		return
	if desired_facing_dir == FACE_DIRS.LEFT:
		position.x = right_x
		facing_dir = FACE_DIRS.LEFT
		top_sprite.flip_h= false
		bot_sprite.flip_h = false
		beam_rays.rotation_degrees = 0
	else:
		position.x = left_x
		facing_dir = FACE_DIRS.RIGHT
		top_sprite.flip_h = true
		bot_sprite.flip_h = true
		beam_rays.rotation_degrees = 180
		
func _see_player():
	for ray in beam_rays.get_children():
		var collider = ray.get_collider()
		if collider == null or not("Player" in collider.get_groups()):
			return false
	return true
	
func _lose_power():
	pass
	
func _idle():
	pass

func destroy_battery():
	destoryed_batteries += 1
	if destoryed_batteries == total_batteries:
		shutdown = true
	
func _destroy_map():
	if map_destroyed and not phase == PHASES.FINAL:
		return
	emit_signal("destroy_map")
	map_destroyed = true
	destroying_map = false
	
func _shutdown():
	phase = PHASES.FINAL
	facing_dir = FACE_DIRS.LEFT
	position = restart_pos
	_destroy_map()
	


