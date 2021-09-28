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


func _update_move_direction():
	parent.move_direction = (-int(Input.is_action_pressed("ui_left")) + 
							  int(Input.is_action_pressed("ui_right")))

func _get_transition(_delta):
	match state:
		states.idling:
			if !parent.is_grounded():
				if parent.is_jumping():
					return states.jumping
				elif parent.is_falling():
					return states.falling
				elif parent.is_on_wall():
					return states.wall_sliding
			elif parent.is_running():
				return states.running
		states.running:
			if parent.is_on_wall():
				return states.wall_sliding
			if !parent.is_grounded():
				if parent.is_jumping():
					return states.jumping
				elif parent.is_falling():
					return states.falling
				elif parent.is_on_wall():
					return states.wall_sliding
			elif !parent.is_running():
				return states.idling
		states.jumping:
			if parent.is_grounded():
				if parent.is_running():
					return states.running
				else:
					return states.idling
			elif parent.is_falling():
					return states.falling
			elif parent.is_on_wall():
				return states.wall_sliding
		states.falling:
			if parent.is_grounded():
				if parent.is_running():
					return states.running
				else:
					return states.idling
			if parent.is_on_wall():
				return states.wall_sliding
		states.absorbing:
			pass
		states.dashing:
			pass
		states.wall_sliding:
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


func _enter_state(new_state, _old_state):
	parent.label.text = states.keys()[new_state]
			

func _exit_state(_old_state, _new_state):
	pass

	
