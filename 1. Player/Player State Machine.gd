extends StateMachine 

export var idling_cutoff = 1
func _ready():
	add_state("running")
	add_state("falling")
	add_state("absorbing")
	add_state("dashing")
	add_state("jumping")
	add_state("idling")
	call_deferred("set_state", states.idling)
	
func _state_logic(delta):
	parent._handle_move_input()
	parent._apply_gravity(delta)
	parent._apply_movement()

func _input(event):
	if [states.idling, states.running].has(state):
		if event.is_action_pressed("ui_up"):
			if parent._check_if_grounded() or !parent.coyote_timer.is_stopped():
				parent.coyote_timer.stop()
				parent._jump()
			else:
				parent.jump_buffer.start()
		
func _get_transition(delta):
	match state:
		states.idling:
			if !parent.is_grounded:
				if parent.velocity.y < 0:
					return states.jumping
				elif parent.velocity.y > 0:
					return states.falling
			elif abs(parent.velocity.x) > 1:
				return states.running
		states.running:
			if !parent.is_grounded:
				if parent.velocity.y < 0:
					return states.jumping
				elif parent.velocity.y > 0:
					return states.falling
			elif abs(parent.velocity.x) < idling_cutoff:
				return states.idling
		states.jumping:
			if parent.is_grounded:
				if abs(parent.velocity.x) > idling_cutoff:
					return states.running
				else:
					return states.idling
			else:
				if parent.velocity.y > 0:
					return states.falling
		states.falling:
			if parent.is_grounded:
				if abs(parent.velocity.x) > idling_cutoff:
					return states.running
				else:
					return states.idling
					
			
				


func _enter_state(new_state, old_state):
	match new_state:
		states.running:
			print("running")
			parent.anim_tree_state_machine.travel("running")
		states.idling:
			print("idling")
			parent.anim_tree_state_machine.travel("idling")
		states.falling:
			print("falling")
			parent.anim_tree_state_machine.travel("falling")
		states.jumping:
			print("jumping")
			parent.anim_tree_state_machine.travel("jumping")
		states.dashing:
			print("dashing")
		states.absorbing:
			print("absorbing")
		
	
func _exit_state(old_state, new_state):
	pass
	#if old_state == states.search:
	#	parent.animation.stop()

	
