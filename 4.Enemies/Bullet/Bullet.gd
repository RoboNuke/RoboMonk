extends Area2D

onready var collision_cap = $CollisionShape2D
onready var sprite = $Sprite

export var velocity = 20
export var momentum = 30  #momentum for absorbtion
export(Texture) var bullet_texture 


var direction = Vector2(1,0)
var bullet_dirs = [225, 270, 315, 0, 45, 90, 135, 180]

func _ready():
	sprite.texture = bullet_texture
	#release(Vector2(100,75), Vector2(1,0))
	
func release(pos, dir):
	position = pos
	direction = dir
	var anim_idx = get_anim_idx(direction)
	#print("Bullet Dir:", bullet_dirs[anim_idx])
	sprite.frame = anim_idx
	set_collision_angle(anim_idx)

func get_anim_idx(dir):
	var ang = rad2deg(dir.angle())
	ang = ang if ang > 0 else ang + 360 # put the angle in 0-360
	#print("Angle:", ang)
	for i in range(len(bullet_dirs)):
		var text_ang = bullet_dirs[i]
		if text_ang == 0:
			if ( ang >= 315+45.0/2 or ang <= 45.0/2):
				return i
		else:
			#print("\tMax:", text_ang + 45.0/2)
			#print("\tMin:", text_ang - 45.0/2)
			if ang <= text_ang + 45.0/2 and ang >= text_ang - 45.0/2:
				#print("Returned:", i)
				return i
	
func set_collision_angle(anim_idx):
	collision_cap.rotation_degrees = bullet_dirs[anim_idx] + 90
	
func _physics_process(delta):
	position += direction * velocity * delta
	#print(global_position)

func get_momentum():
	return momentum
	
func absorbed():
	pass

func _on_Bullet_body_entered(body):
	if "Player" in body.get_groups():
		body.hit(self)
		print("Hit PLayer")
	elif "Wall" in body.get_groups():
		print("Hit Wall")
	self.queue_free()
