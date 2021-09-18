extends Node2D

onready var door_timer = $"Door Activation Box/Timer"
onready var sprite = $"Sprite"
onready var collision_box = $"Door Activation Box/CollisionShape2D"
onready var electro_box = $"Door Collider/CollisionShape2D"
var flash_frame = 0

export var start_closed = false
export var open = true
#func _ready():
#	sprite.frame = 0
func _ready():
	if start_closed:
		_on_Door_body_entered(null)
	
func open():
	sprite.frame = 0
	open = true

func _on_Door_body_entered(body):
	sprite.frame = flash_frame + 1
	door_timer.start()
	open = false
	
func _on_Timer_timeout():
	if not open:
		flash_frame = (flash_frame + 1) % 2
		sprite.frame = flash_frame + 1
		door_timer.start()
