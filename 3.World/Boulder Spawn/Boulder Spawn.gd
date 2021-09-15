extends RigidBody2D

onready var drop_timer = $"Drop Timer"
onready var shake_timer = $"Shake Timer"


export(PackedScene) var boulder = preload("res://3.World/Boulder Spawn/Boulder.tscn")

export(Texture) var boulder_texture 
export var boulder_speed = Vector2(0,0)
export var boulder_gravity = Vector2(0,10.0/60.0)
export var boulder_momentum = 300
export var DROP_OFFSET = 17

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(10, 8)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
var start = false
var init_position

func _ready():
	randomize()
	init_position = position
	visible = true
	
func _process(_delta):
	if !start:
		return
	if drop_timer.is_stopped() and shake_timer.is_stopped():
		position = init_position
		visible = false
		drop_timer.start()
		spawn_spike()
		
	if !shake_timer.is_stopped():
		visible = true
		shake()

	
func shake():
	#rotation = max_roll * rand_range(-1, 1)
	position.x = max_offset.x * rand_range(-1, 1) + init_position.x
	position.y = max_offset.y * rand_range(-1, 1) + init_position.y

func spawn_spike():
	var s = boulder.instance()
	s.set("boulder_texture", boulder_texture)
	s.set("velocity", boulder_speed)
	s.set("momentum", boulder_momentum)
	s.set("grav", boulder_gravity)
	s.drop(global_position + Vector2(0, DROP_OFFSET))
	get_tree().root.call_deferred("add_child",s)


func _on_Drop_Timer_timeout():
	shake_timer.start()


func _on_Area2D_body_entered(_body):
	start = true
