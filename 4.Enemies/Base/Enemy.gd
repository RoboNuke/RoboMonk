extends KinematicBody2D

#onready var weapon = $Shoulder/Hand/Melee
onready var hand = $Shoulder/Hand
onready var shoulder = $Shoulder
onready var fov = $Shoulder/FieldOfView
onready var animation = $AnimationPlayer
onready var animation_tree

export var speed = 100
export var snap = Vector2(0,25)
var FLOOR_NORMAL = Vector2.UP

var player 
var velocity = Vector2.ZERO

func _ready():
	animation_tree = $AnimationTree.get("parameters/playback")
	
	
var last_hit = null
func hit(hitter):
	if last_hit != hitter:
		queue_free()

func _physics_process(_delta):
	_check_fov()
	if player == null:
		return
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL, false, 4, deg2rad(60))

func _chase():
	shoulder.look_at(player.position)
	# move only in x 
	var dir: Vector2 = Vector2(1,0) if global_position.x < player.position.x else Vector2(-1,0)
	velocity = dir * speed

func _search():
	velocity = Vector2.ZERO
	
func _attack():
	shoulder.look_at(player.position)
	var _dir = (player.global_position - global_position).normalized()
	#weapon.fire(hand.global_position, dir)
	velocity = Vector2.ZERO
	#shoulder.look_at(player.global_position)
	
func _check_fov():
	var in_warn_area = false
	var in_danger_area = false
	fov.check_view()
	for hit in fov.in_danger_area:
		if "Player" in hit.get_groups():
			player = hit
			in_danger_area = true
	for hit in fov.in_warn_area:
		if "Player" in hit.get_groups():
			player = hit
			in_warn_area = true
			
	return( [in_danger_area, in_warn_area] )
	


