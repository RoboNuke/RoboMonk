extends Area2D

onready var collision_cap = $CollisionShape2D
onready var sprite = $Sprite

export var velocity = 20
var direction = Vector2(0,1)
export var momentum = 30  #momentum for absorbtion
export(Texture) var spike_texture 


func _ready():
	sprite.texture = spike_texture
	#drop(Vector2(100,75))
	
func drop(pos, rot):
	position = pos
	direction = Vector2(0,1).rotated(rot)
	rotation_degrees = rad2deg(rot)

func _process(_delta):
	position += direction * velocity

func get_momentum():
	return momentum
	
func absorbed():
	pass

func _on_Boulder_body_entered(body):
	if "Player" in body.get_groups():
		body.hit(self)
		print("Hit PLayer")
	elif "Hittable" in body.get_groups():
		body.hit(self)
	elif "Wall" in body.get_groups():
		pass
		#print("Hit Wall")
	self.queue_free()


func _on_Spike_body_entered(body):
	if "Player" in body.get_groups():
		body.hit(self)
		print("Hit PLayer")
	elif "Hittable" in body.get_groups():
		body.hit(self)
	elif "Wall" in body.get_groups():
		pass
		#print("Hit Wall")
	self.queue_free()
