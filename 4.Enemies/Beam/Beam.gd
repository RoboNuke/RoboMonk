extends Area2D

onready var collision_cap = $CollisionShape2D
onready var sprite = $Sprite

enum BEAM_LOCS {RIGHT_END=2, MIDDLE=1, LEFT_END=0}

export var velocity = 20
export var momentum = 30  #momentum for absorbtion
export(Texture) var beam_texture 


var direction = Vector2(1,0)

func _ready():
	sprite.texture = beam_texture
	#release(Vector2(100,75), Vector2(1,.5), BEAM_LOCS.LEFT_END)
	
func release(pos, dir, beam_location):
	position = pos
	direction = dir
	var release_angle = rad2deg(dir.angle())
	#print("Bullet Dir:", bullet_dirs[anim_idx])
	sprite.frame = beam_location
	sprite.rotation_degrees = release_angle

func add_to_beam():
	pass

func _physics_process(delta):
	position += direction * velocity * delta

func get_momentum():
	return momentum
	
func absorbed():
	pass

func _on_Bullet_body_entered(body):
	if "Player" in body.get_groups():
		body.hit(self)
	elif "Hittable" in body.get_groups():
		body.hit(self)
	elif "Wall" in body.get_groups():
		pass#print("Hit Wall")
	self.queue_free()
