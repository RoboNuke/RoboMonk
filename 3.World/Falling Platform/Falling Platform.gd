extends Node2D

onready var rays = $Rays
onready var stable_timer = $"Stable Timer"
onready var player = $AnimationPlayer

#func _ready():
#	stable_timer.start()

func _process(_delta):
	for ray in rays.get_children():
		ray.force_raycast_update()
		if ray.is_colliding():
			player.play("Fall")


func _on_Stable_Timer_timeout():
	player.play("Fall")
