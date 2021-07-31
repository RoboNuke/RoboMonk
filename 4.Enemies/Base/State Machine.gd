extends StateMachine

func _ready():
	add_state("search")
	add_state("chase")
	add_state("attack")
	call_deferred("set_state", states.search)
	
func _state_logic(delta):
	
	if state == states.search:
		parent._search()
	elif state == states.chase:
		parent._chase()
	elif state == states.attack:
		parent._attack()
	
func _get_transition(delta):
	var player_in_fov = parent._check_fov()
	match state:
		states.search:
			if player_in_fov[0]: # in danger zone
				return states.attack
			elif player_in_fov[1]:
				return states.chase
		states.chase:
			if player_in_fov[0]:
				return states.attack
			elif !(player_in_fov[1]):
				return states.search
		states.attack:
			if player_in_fov[1]:
				return states.chase
			elif !player_in_fov[0]:
				return states.search
				
			
	
func _enter_state(new_state, old_state):
	#if old_state != null:
	#	print("From ", states.get_key(old_state), " to ", states.get_key(new_state))
	#previous_state = old_state
	#state = new_state
	match new_state:
		states.search:
			print("search")
			parent.animation_tree.travel("search")
		states.chase:
			print("chase")
			parent.animation_tree.travel("idle")
		states.attack:
			print("attack")
			parent.animation_tree.travel("idle")
	
func _exit_state(old_state, new_state):
	if old_state == states.search:
		parent.animation.stop()
	pass
