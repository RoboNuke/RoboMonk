extends StateMachine

func _ready():
	active = false
	add_state("idle")
	
func _state_logic(_delta):
	match state:
		states.idle:
			parent.bot_player.play("off")
			parent.top_player.play("Idle")

func _get_transition(_delta):
	match state:
		states.idle:
			pass
	
func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			print("Dragon Boss Final::Idling")

func _start():
	active = true
	call_deferred("set_state", states.idle)
	

func _exit_state(_old_state, _new_state):
	pass

	
