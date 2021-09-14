extends Area2D

onready var drop_timer = $"Drop Timer"
export(PackedScene) var boulder = preload("res://3.World/Boulder Spawn/Launched Boulder.tscn")

export(Vector2) var launch_impulse = Vector2(0,-200)
export(float) var Boulder_ROF = 4

func _ready():
	drop_timer.wait_time = Boulder_ROF
	drop_timer.start()
	

func fire_boulder():
	var b = boulder.instance()
	b.position = global_position
	b.apply_impulse(Vector2.ZERO, launch_impulse)
	get_tree().get_root().add_child(b)
	
	
func _on_Drop_Timer_timeout():
	print("Fire")
	fire_boulder()
	$"Drop Timer".start()
