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
			#else:
			#	parent.jump_buffer.start()

func _update_move_direction():
	parent.move_direction = (-int(Input.is_action_pressed("ui_left")) + 
								int(Input.is_action_pressed("ui_right")))

		
func _get_transition(_delta):
	match state:
		states.idling:
			pass
		states.running:
			pass
		states.jumping:
			pass
		states.falling:
			pass
		states.absorbing:
			pass
		states.dashing:
			pass
		states.wall_sliding:
			pass	


func _enter_state(new_state, _old_state):
		#print("reduce mod")
	match new_state:
		states.running:
			print("running")
		states.idling:
			print("idling")
		states.falling:
			print("falling")
		states.jumping:
			print("jumping")
		states.dashing:
			print("dashing")
		states.absorbing:
			print("absorbing")
		states.wall_sliding:
			print("wall sliding")
			

func _exit_state(_old_state, _new_state):
	pass

	
