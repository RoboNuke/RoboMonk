extends KinematicBody2D

#onready var weapon = $Shoulder/Hand/Melee
onready var hand = $Shoulder/Hand
onready var shoulder = $Shoulder
onready var fov = $Shoulder/FieldOfView
onready var animation = $AnimationPlayer

export var speed = 100
export var snap = Vector2(0,25)
export var GRAVITY = 1200
export var CLOSEST_DISTANCE = 2
var FLOOR_NORMAL = Vector2.UP

var player 
var velocity = Vector2.ZERO
	
var last_hit = null
func hit(hitter):
	if last_hit != hitter:
		queue_free()

func _physics_process(delta):
	_check_fov()
	#if player == null:
	#	return
	_apply_gravity()
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL, false, 4, deg2rad(60))

func _chase():
	shoulder.look_at(player.position)
	if abs(shoulder.rotation_degrees + 90) < 2:
		shoulder.rotation_degrees = -90
	# move only in x 
	var dir: Vector2 = Vector2(1,0) if global_position.x < player.position.x else Vector2(-1,0)
	if abs(global_position.x - player.position.x) > CLOSEST_DISTANCE:
		velocity = dir * speed
	else:
		velocity = Vector2(0,0)

func _search():
	velocity = Vector2.ZERO
	
func _attack():
	shoulder.look_at(player.position)
	var dir = (player.global_position - global_position).normalized()
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

func _apply_gravity():
	velocity.y += GRAVITY
	

