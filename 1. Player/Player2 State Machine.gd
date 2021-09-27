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

func _update_move_direction():
	parent.move_direction = (-int(Input.is_action_pressed("ui_left")) + 
								int(Input.is_action_pressed("ui_right")))

		
func _get_transition(_delta):
	match state:
		states.idling:
			if !parent.grounded:
				if parent.velocity.y < 0:
					return states.jumping
				elif parent.velocity.y > 0:
					return states.falling
			elif abs(parent.velocity.x) > 1:
				return states.running
		states.running:
			if !parent.grounded:
				if parent.velocity.y < 0:
					return states.jumping
				elif parent.velocity.y > 0:
					return states.falling
			elif abs(parent.velocity.x) < 1:
				return states.idling
		states.jumping:
			if parent.grounded:
				if abs(parent.velocity.x) > idling_cutoff:
					return states.running
				else:
					return states.idling
			else:
				if parent.velocity.y > 0:
					return states.falling
		states.falling:
			if parent.grounded:
				if abs(parent.velocity.x) > idling_cutoff:
					return states.running
				else:
					return states.idling
		states.absorbing:
			pass
		states.dashing:
			pass
		states.wall_sliding:
			pass	


func _enter_state(new_state, _old_state):
	parent.label.text = states.keys()[new_state]
			

func _exit_state(_old_state, _new_state):
	pass

	
