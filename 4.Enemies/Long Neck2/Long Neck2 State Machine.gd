extends StateMachine 

func _ready():
	add_state("search")
	add_state("attack")
	add_state("track")
	call_deferred("set_state", states.search)
	
func _state_logic(_delta):
	match state:
		states.search:
			parent.search()
		states.track:
			parent.track()
		states.attack:
			parent.attack()

func _get_transition(_delta):
	if parent.can_attack():
		return states.attack
	elif parent.could_attack():
		return states.track
	else:
		return states.search

func _enter_state(new_state, old_state):
	if new_state != old_state:
		print("I am ", states.keys()[state], "ing")
	
func _exit_state(_old_state, _new_state):
	pass
	
