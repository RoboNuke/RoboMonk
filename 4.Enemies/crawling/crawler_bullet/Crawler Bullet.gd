extends Area2D

onready var collision_cap = $CollisionShape2D
onready var sprite = $Sprite

export var velocity = 200
var direction = Vector2(1,0)
export var fire_speed = 1  #seconds between shots

var anim_ranges = [45/2, 45+45/2, 90+45/2, 180-45/2, 180+45/2]
var directions = ["right", "up_right", "up", "up_left", "left"]
var anim_loc = [4, 2, 1, 0, 3]

func release(pos, dir):
	position = pos
	direction = dir
	var anim_idx = get_anim_zone(dir)
	sprite.frame = int(anim_loc[anim_idx])
	set_collision_angle(anim_idx)
	
func set_collision_angle(anim_idx):
	collision_cap.rotation_degrees = anim_ranges[anim_idx] - 45/2

func get_anim_zone(vec_dir):
	# returns the animation idx and the angle that animation is facing
	var ang = -rad2deg(vec_dir.angle())  # -90 is straigh up so add (-) to make 90 up
	for i in range(len(anim_ranges)):
		if ang < anim_ranges[i]:
			return i
	return len(anim_ranges)
func _physics_process(delta):
	position += direction * velocity * delta
	#print(global_position)


func _on_Bullet_body_entered(body):
	if "Player" in body.get_groups():
		body.hit(self)
		print("Hit PLayer")
	elif "Wall" in body.get_groups():
		print("Hit Wall")
		pass
	elif "Enemy" in body.get_groups():
		body.hit(body)
		print("hit enemy")
	self.queue_free()
