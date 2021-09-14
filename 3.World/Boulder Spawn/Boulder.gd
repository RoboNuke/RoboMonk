extends Area2D

onready var collision_cap = $CollisionShape2D
onready var sprite = $Sprite

export var grav = Vector2(0,10)
export var velocity = Vector2(0,0)
export var momentum = 30  #momentum for absorbtion
export(Texture) var boulder_texture


func _ready():
	sprite.texture = boulder_texture
	
func drop(pos):
	position = pos
	
func _process(delta):
	velocity += grav
	position += velocity

func get_momentum():
	return momentum
	
func absorbed():
	pass

func _on_Boulder_body_entered(body):
	if "Player" in body.get_groups():
		body.hit(self)
		#print("Hit PLayer")
	elif "Hittable" in body.get_groups():
		body.hit(self)
	elif "Wall" in body.get_groups():
		print("Hit Wall")
	elif "Deadly Floor" in body.get_groups():
		if velocity.y <= 0:
			return
	self.queue_free()
