extends KinematicBody2D

onready var animation = $AnimationPlayer
onready var animation_fire = $"Fire Animator"
onready var rof = $ROF
onready var fire_sprite = $"Fire Sprite"

export var bullet = preload("res://4.Enemies/Long Neck/long_neck_bullet/Long Neck Bullet.tscn")

export var CLOSEST_DISTANCE = 2
export var MUZZLE_OFFSET = 10
var INIT_MUZZLE_HEIGHT = 5

enum FACE_DIRS {LEFT=0, RIGHT=1}
enum HEIGHTS {lvl_0 = 0, lvl_1 = 1, lvl_2 = 2, lvl_3 = 3,lvl_4 = 4,lvl_5 = 5,lvl_6 = 6,lvl_7 = 7,lvl_8 = 8,lvl_9 = 9,lvl_10 = 10,lvl_11 = 11}

export(FACE_DIRS) var facing_dir = FACE_DIRS.LEFT
var desired_facing_dir = facing_dir
export(bool) var can_turn_around = true
var desired_fire_dir = Vector2.LEFT if facing_dir == FACE_DIRS.LEFT else Vector2.RIGHT

export(HEIGHTS) var max_height = HEIGHTS.lvl_4
var current_height = HEIGHTS.lvl_0

var FLOOR_NORMAL = Vector2.UP
var player 
var velocity = Vector2.ZERO

var anim_tree_state_machine = null
var delta_height = 1
var see_player = false

	
var last_hit = null

func hit(hitter):
	if last_hit != hitter:
		queue_free()

func _search():
	pass

func _search_step():
	if can_turn_around and current_height + delta_height > max_height:
		facing_dir = (facing_dir + 1 )%2
	if current_height + delta_height > max_height or current_height + delta_height < 0:
		delta_height = - delta_height
	
	
	current_height += delta_height
	
func _attack():
	if not can_turn_around:
		return 
	if player.global_position.x < global_position.x:
		desired_facing_dir = FACE_DIRS.LEFT
		desired_fire_dir = Vector2.LEFT
	else:
		desired_facing_dir = FACE_DIRS.RIGHT
		desired_fire_dir = Vector2.RIGHT
	
func _fire():
	if rof.is_stopped():
		var b = bullet.instance()
		get_tree().root.add_child(b)
		b.release(global_position + Vector2(MUZZLE_OFFSET * desired_fire_dir.x, -(INIT_MUZZLE_HEIGHT + 2*current_height)), desired_fire_dir)
		rof.start()
	
func _on_Area2D_body_entered(body):
	if "Player" in body.get_groups():
		player = body
		see_player = true


func _on_Area2D_body_exited(body):
	if "Player" in body.get_groups():
		see_player = false
