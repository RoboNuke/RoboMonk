extends KinematicBody2D

#onready var weapon = $Shoulder/Hand/Melee
onready var hand = $Shoulder/Hand
onready var shoulder = $Shoulder
onready var fov = $Shoulder/FieldOfView
onready var animation = $AnimationPlayer
onready var rof = $ROF

var bullet = preload("res://4.Enemies/Bullet/Bullet.tscn")

export(bool) var can_move = true
export(Texture) var bullet_texture
export var bullet_speed = 200
export var bullet_momentum = 300
export var speed = 100
export var snap = Vector2(0,25)
export var GRAVITY = 1200
export var CLOSEST_DISTANCE = 2
export var muzzle_offset = 6
export var X_AIM_OFFSET = 0
export var Y_AIM_OFFSET = 5
var FLOOR_NORMAL = Vector2.UP

var player 
var velocity = Vector2.ZERO
	
var last_hit = null
func hit(hitter):
	if last_hit != hitter:
		queue_free()

func _physics_process(_delta):
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
	velocity = Vector2.ZERO
	shoulder.look_at(player.position)
	var dir = ((player.global_position + Vector2(X_AIM_OFFSET,Y_AIM_OFFSET)) - global_position ).normalized()
	#dir.y -= 3
	#print(player.global_position, " ", global_position)
	return _fire(dir)
	
func _fire(dir):
	if rof.is_stopped():
		print("Fire")
		var b = bullet.instance()
		b.set("bullet_texture", bullet_texture)
		b.set("velocity", bullet_speed)
		b.set("momentum", bullet_momentum)
		get_tree().root.add_child(b)
		b.release(hand.global_position + muzzle_offset * dir, dir)
		rof.start()
		return true
	return false

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
	

