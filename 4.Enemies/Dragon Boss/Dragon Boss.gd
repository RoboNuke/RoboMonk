extends KinematicBody2D

onready var bot_sprite = $"Bottom Sprite"
onready var top_sprite = $"Top Sprite"
onready var bot_player = $"Bottom Player"
onready var top_player = $"Top Player"
onready var tween = $"Tween"
onready var laser_sm = $"Laser Only State Machine"
onready var mouth_sm = $"Mouth Gun State Machine"
onready var beam_cd = $"Beam CD"
onready var beam_rof = $"Beam ROF"
onready var beam_rays = $"Beam Spawn/Beam Rays"
onready var beam_spawn = $"Beam Spawn"
var player

enum FACE_DIRS {LEFT=0, RIGHT=1}
enum PHASES {INIT=0, FINAL=1}
enum MOVE_DIRS {UP=1, DOWN=-1, NONE=0}
enum ACTION_TRIGGERS {SWITCH_RIGHT=0, SWITCH_LEFT=1}

var velocity = Vector2.ZERO

# beam vars
var beam = preload("res://4.Enemies/Beam/Beam.tscn")
export(Texture) var beam_texture 
export var beam_speed = 100.0
export var beam_momentum = 200
export var max_beam_length = 15
export(Vector2) var BEAM_OFFSET = Vector2(10,30)
var beams_fired = 0

#state vars
var facing_dir = FACE_DIRS.LEFT
var desired_facing_dir = FACE_DIRS.LEFT
var firing = false
var move_dir = MOVE_DIRS.UP
var opening_jaw = false
var phase = PHASES.INIT
export(Vector2) var speed = Vector2(600,75)
export var muzzle_offset = 20
var left_x 
var right_x

var beam_width = 6.0
func _ready():
	pass

func start(pos):
	global_position = pos
	laser_sm.start()
	
func set_boss_data(data):
	left_x = data[0]
	right_x = data[1]
	print(beam_width/beam_speed)
	beam_rof.set_wait_time(beam_width/beam_speed)
	
func _process(_delta):
	if firing and beams_fired >= max_beam_length:
		firing = false
		beams_fired = 0
		beam_cd.start()
	velocity.y = speed.y * move_dir
	velocity = move_and_slide(velocity)

func trigger_action(action):
	if action == ACTION_TRIGGERS.SWITCH_RIGHT:
		desired_facing_dir = FACE_DIRS.LEFT
	elif action == ACTION_TRIGGERS.SWITCH_LEFT:
		desired_facing_dir = FACE_DIRS.RIGHT
		
# this could be used to go up/down on a fixed track
var counter = 1
func _search_player():
	if !tween.is_active():
		#position.y += 200 * -1 ^ counter
		tween.interpolate_property(self, "position:y",
		  position.y, position.y + 200 * pow(-1,counter), 3,
		  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		counter = (counter + 1)%2
		print("Start Tween")

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
	
func _destroy_map():
	pass
	
func _shutdown():
	pass


