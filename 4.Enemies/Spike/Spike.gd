extends Area2D

onready var collision_cap = $CollisionShape2D
onready var sprite = $Sprite

export var velocity = 20
export var momentum = 30  #momentum for absorbtion
export(Texture) var spike_texture 


func _ready():
	sprite.texture = spike_texture
	print("Spike Ready")
	#drop(Vector2(100,75))
	
func drop(pos):
	position = pos
	print(sprite.texture)
func _process(_delta):
	position.y += velocity
	

func get_momentum():
	return momentum
	
func absorbed():
	pass

func _on_Spike_body_entered(body):
	if "Player" in body.get_groups():
		body.hit(self)
		print("Hit PLayer")
	elif "Hittable" in body.get_groups():
		body.hit(self)
	elif "Wall" in body.get_groups():
		print("Hit Wall")
	self.queue_free()
