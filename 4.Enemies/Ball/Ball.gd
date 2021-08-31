extends Area2D

onready var collision_cap = $CollisionShape2D

enum BEAM_LOCS {RIGHT_END=2, MIDDLE=1, LEFT_END=0}

export var velocity = 20
export var momentum = 30  #momentum for absorbtion


var direction 

func _ready():
	#release(Vector2(100,75), Vector2(1,.5), BEAM_LOCS.LEFT_END)
	pass

func release(pos, dir):
	position = pos
	direction = dir

func add_to_beam():
	pass

func _physics_process(delta):
	position += direction * velocity * delta

func get_momentum():
	return momentum
	
func absorbed():
	pass

func _on_Ball_body_entered(body):
	print(body.get_groups())
	if "Player" in body.get_groups():
		body.hit(self)
		print("Hit PLayer")
	elif "Hittable" in body.get_groups():
		body.hit(self)
	elif "Wall" in body.get_groups():
		print("Hit Wall")
	self.queue_free()
