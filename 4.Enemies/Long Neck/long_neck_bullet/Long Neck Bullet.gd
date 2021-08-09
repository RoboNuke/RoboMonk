extends Area2D

onready var collision_cap = $CollisionShape2D
onready var sprite = $Sprite

export var velocity = 200
export var momentum = 300  #momentum for absorbtion
var direction = Vector2(1,0)
export var fire_speed = 1  #seconds between shots

var anim_ranges = [90, -90]
var directions = ["right", "left"]
var anim_loc = [6,2]

func release(pos, dir):
	position = pos
	direction = dir
	var anim_idx = 0 if dir == Vector2.RIGHT else 1
	sprite.frame = int(anim_loc[anim_idx])
	set_collision_angle(anim_idx)
	
func set_collision_angle(anim_idx):
	collision_cap.rotation_degrees = anim_ranges[anim_idx]
	
func _physics_process(delta):
	position += direction * velocity * delta
	#print(global_position)

func absorbed():
	pass

func _on_Bullet_body_entered(body):
	if "Player" in body.get_groups():
		body.hit(self)
		print("Hit PLayer")
	elif "Wall" in body.get_groups():
		print("Hit Wall")
	self.queue_free()
