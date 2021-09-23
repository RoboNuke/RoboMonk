extends RigidBody2D



export(PackedScene) var spike

export(Texture) var spike_texture 
export var spike_speed = 2
export var spike_momentum = 300
export var DROP_OFFSET = 17

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].


func _ready():
	randomize()
	
func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
	
func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * rand_range(-1, 1)
	position.x = max_offset.x * amount * rand_range(-1, 1)
	position.y = max_offset.y * amount * rand_range(-1, 1)

func spawn_spike():
	var s = spike.instance()
	s.set("spike_texture", spike_texture)
	s.set("velocity", spike_speed)
	s.set("momentum", spike_momentum)
	get_tree().root.call_deferred("add_child",s)
	s.drop(global_position + Vector2(0, DROP_OFFSET).rotated(deg2rad(rotation_degrees)), deg2rad(rotation_degrees))

func _on_Area2D_body_entered(_body):
	spawn_spike()
