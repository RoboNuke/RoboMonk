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
	parent._update_move_direction()
	parent._update_wall_direction()
	if state != states.wall_sliding:
		parent._handle_move_input()
	else:
		parent.desired_look_direction = -parent.wall_direction
	parent._face_desired_direction()
	parent._apply_gravity(delta)
	if state == states.wall_sliding:
		parent._cap_gravity_wall_sliding()
	parent._apply_movement()
	
func _input(event):
	if [states.idling, states.running].has(state):
		if event.is_action_pressed("ui_up"):
			if parent._check_if_grounded() or !parent.coyote_timer.is_stopped():
				parent.coyote_timer.stop()
				parent._jump()
			else:
				parent.jump_buffer.start()
	if [states.wall_sliding].has(state):
		if event.is_action_pressed("ui_up"):
			parent._jump(true)
		if event.is_action_pressed("ui_right") and parent.wall_direction == -1:
			parent.velocity.x = 50
		if event.is_action_pressed("ui_left") and parent.wall_direction == 1:
			parent.velocity.x = -50
	if not [states.absorbing, states.dashing].has(state):
		if event.is_action_pressed("action"):
			parent._absorb()
	if [states.absorbing].has(state):
		if event.is_action_released("action") or parent.max_absorb.is_stopped():
			parent._dash()
		
func _get_transition(_delta):
	match state:
		states.idling:
			if not parent.is_absorbing:
				if !parent.is_grounded:
					if parent.velocity.y < 0:
						return states.jumping
					elif parent.velocity.y > 0:
						return states.falling
				elif abs(parent.velocity.x) > 1:
					return states.running
			else:
				return states.absorbing
			
		states.running:
			if not parent.is_absorbing:
				if !parent.is_grounded:
					if parent.velocity.y < 0:
						return states.jumping
					elif parent.velocity.y > 0:
						return states.falling
				elif abs(parent.velocity.x) < idling_cutoff:
					return states.idling
			else:
				return states.absorbing
		states.jumping:
			if not parent.is_absorbing:
				if parent.wall_direction != 0:
					return states.wall_sliding
				if parent.is_grounded:
					if abs(parent.velocity.x) > idling_cutoff:
						return states.running
					else:
						return states.idling
				else:
					if parent.velocity.y > 0:
						return states.falling
			else:
				return states.absorbing
				
		states.falling:
			if parent.is_absorbing:
				return states.absorbing
			if parent.wall_direction != 0:
				return states.wall_sliding
			if parent.is_grounded:
				if abs(parent.velocity.x) > idling_cutoff:
					return states.running
				else:
					return states.idling
		states.absorbing:
			if parent.is_dashing:
				return states.dashing
		states.dashing:
			if parent.is_grounded:
				return states.idling
			if parent.wall_direction != 0:
				return states.wall_sliding
			if !parent.is_dashing:
				if parent.velocity.y > 0:
					return states.falling
				else:
					return states.jumping

		states.wall_sliding:
			if parent.is_absorbing:
				return states.absorbing
			if parent.is_grounded:
				return states.idling
			if parent.wall_direction == 0:
				if parent.velocity.y > 0:
					return states.falling
				elif parent.velocity.y < 0:
					return states.jumping
				


func _enter_state(new_state, _old_state):
	match new_state:
		states.running:
			
			#print("running")
			parent.anim_tree_state_machine.travel("running")
		states.idling:
			#print("idling")
			parent.anim_tree_state_machine.travel("idling")
		states.falling:
			#print("falling")
			parent.anim_tree_state_machine.travel("falling")
		states.jumping:
			#print("jumping")
			parent.anim_tree_state_machine.travel("jumping")
		states.dashing:
			parent.anim_tree_state_machine.travel("dashing")
			#print("dashing")
		states.absorbing:
			parent.anim_tree_state_machine.travel("absorbing")
			#print("absorbing")
		states.wall_sliding:
			#print_debug("wall sliding")
			parent.anim_tree_state_machine.travel("wall slide")
func _exit_state(_old_state, _new_state):
	pass
	#if old_state == states.search:
	#	parent.animation.stop()

	
