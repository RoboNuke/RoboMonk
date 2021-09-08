extends RigidBody2D



export(PackedScene) var spike

export(Texture) var spike_texture 
export var spike_speed = 2
export var spike_momentum = 300
export var DROP_OFFSET = 17

func _ready():
	pass
	#global_position = Vector2(100,20)
	#call_deferred("spawn_spike")
	
func spawn_spike():
	var s = spike.instance()
	s.set("spike_texture", spike_texture)
	s.set("velocity", spike_speed)
	s.set("momentum", spike_momentum)
	get_tree().root.call_deferred("add_child",s)
	s.drop(global_position + Vector2(0, DROP_OFFSET))

func _on_Area2D_body_entered(_body):
	spawn_spike()
