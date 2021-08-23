extends KinematicBody2D

onready var bot_sprite = $"Bottom Sprite"
onready var top_sprite = $"Top Sprite"
onready var bot_player = $"Bottom Player"
onready var top_player = $"Top Player"
onready var tween = $"Tween"
onready var laser_sm = $"Laser Only State Machine"
onready var mouth_sm = $"Mouth Gun State Machine"

var player

enum FACE_DIRS {LEFT=0, RIGHT=1}
enum PHASES {INIT=0, FINAL=1}
enum MOVE_DIRS {UP=1, DOWN=-1, NONE=0}
enum ACTION_TRIGGERS {SWITCH_RIGHT=0, SWITCH_LEFT=1}
var velocity = Vector2.ZERO

#state vars
var facing_dir = FACE_DIRS.LEFT
var desired_facing_dir = FACE_DIRS.LEFT
var move_dir = MOVE_DIRS.UP
var opening_jaw = false
var phase = PHASES.INIT
export(Vector2) var speed = Vector2(600,75)
export var muzzle_offset = 20
var left_x 
var right_x


func _ready():
	pass

func start(pos):
	global_position = pos
	laser_sm.start()
	
func set_boss_data(data):
	left_x = data[0]
	right_x = data[1]
	
func _process(_delta):
	#_check_fov()
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
	print("here")
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
	

func _fire_laser():
	pass

func _change_side():
	if desired_facing_dir == facing_dir:
		return
	if desired_facing_dir == FACE_DIRS.LEFT:
		position.x = right_x
		facing_dir = FACE_DIRS.LEFT
		top_sprite.flip_h= false
		bot_sprite.flip_h = false
	else:
		position.x = left_x
		facing_dir = FACE_DIRS.RIGHT
		top_sprite.flip_h = true
		bot_sprite.flip_h = true
	
func _lose_power():
	pass
	
func _idle():
	pass
	
func _destroy_map():
	pass
	
func _shutdown():
	pass
