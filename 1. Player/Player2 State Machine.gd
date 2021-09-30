extends StateMachine 

export var idling_cutoff = 1
func _ready():
	add_state("running")
	add_state("falling")
	add_state("absorbing")
	add_state("dashing")
	add_state("jumping")
	add_state("idling")
	add_state("wall_sliding")
	call_deferred("set_state", states.idling)
	
func _state_logic(delta):
	_update_move_direction()
	parent.apply_x_velocity()
	parent.apply_gravity(delta)
	parent.apply_movement()

func _input(event):
	if [states.idling, states.running].has(state):
		if event.is_action_pressed("ui_up"):
			if parent.can_jump():
				parent.jump()
			else:
				parent.tried_to_jump()
	if [states.jumping].has(state):
		if event.is_action_released("ui_up"): 
			parent.release_jump()
	if [states.wall_sliding].has(state):
		if event.is_action_pressed("ui_up"):
			parent.wall_jump()
	if not [states.absorbing, states.dashing].has(state):
		if event.is_action_pressed("action") and parent.can_absorb():
			parent.start_absorbing()    
	if [states.absorbing].has(state):
		if event.is_action_released("action") or !parent.is_absorbing():
			parent.dash()


func _update_move_direction():
	parent.move_direction = (-int(Input.is_action_pressed("ui_left")) + 
							  int(Input.is_action_pressed("ui_right")))

func standard_transition():
	if parent.is_absorbing():
		return states.absorbing
	if parent.is_grounded():
		if parent.is_running():
			return states.running
		else:
			return states.idling
	if !parent.is_on_wall():
		if parent.is_falling():
			return states.falling
		elif parent.is_jumping():
			return states.jumping
	else:
		return states.wall_sliding

func _get_transition(_delta):
	var out
	match state:
		states.idling:
			return standard_transition()
		states.running:
			return standard_transition()
		states.jumping:
			return standard_transition()
		states.falling:
			return standard_transition()
		states.absorbing:
			if parent.is_dashing():
				return states.dashing
		states.dashing:
			if !parent.is_dashing():
				return standard_transition()
		states.wall_sliding:
			return standard_transition()


func _enter_state(new_state, _old_state):
	parent.label.text = states.keys()[new_state]
	#print(states.keys()[new_state])
			

func _exit_state(_old_state, _new_state):
	pass

	
