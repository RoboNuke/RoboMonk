extends StateMachine 


func _ready():
	add_state("search")
	add_state("chase")
	add_state("attack")
	call_deferred("set_state", states.search)
	
func _state_logic(_delta):
	match state:
		states.search:
			parent.search()
		states.attack:
			parent.attack()
		states.chase:
			parent.chase()
	
func _std_transition():
	if parent.can_attack():
		return states.attack
	if parent.can_chase():
		return states.chase
	return states.search

func _get_transition(_delta):
	var trans =  _std_transition()
	return trans if trans != state else null

func _enter_state(new_state, _old_state):
	match new_state:
		states.search:
			parent.head_player.play("Search")
			parent.body_player.play("Idle")
			print("Walker2::Searching")
		states.chase:
			parent.body_player.play("Walk")
			parent.head_player.play("Idle")
			print("Walker2::Chasing")
		states.attack:
			parent.body_player.play("Idle")
			parent.head_player.play("Idle")
			
			print("Walker2::Attacking")

func _exit_state(old_state, _new_state):
	pass
