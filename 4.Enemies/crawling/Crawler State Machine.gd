extends StateMachine
var MAX_RIGHT = 45/2
var MAX_UP_RIGHT = 45/2 + MAX_RIGHT
var MAX_UP_LEFT = 90 + 45/2
var MAX_LEFT = 180-45/2

func _ready():
	add_state("idle")
	add_state("search")
	add_state("walk_search")
	add_state("chase")
	add_state("attack")
	call_deferred("set_state", states.search)
	
func _state_logic(delta):
	
	if state == states.search:
		parent._search()
	elif state == states.walk_search:
		parent._walk_search()
	elif state == states.chase:
		parent._chase()
	elif state == states.attack:
		parent._attack()
	elif state == states.idle:
		parent._idle()
	
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
			else:
				_update_chase_animation()
				
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
		states.idle:
			print("idling")
			parent.animation.play("idle")
		states.search:
			print("search")
			parent.animation.play("search 3")
		states.chase:
			print("chase")
			_update_chase_animation()
		states.attack:
			print("attack")

func _exit_state(old_state, new_state):
	if old_state == states.search:
		parent.animation.stop()
	pass

func _set_chase_animation(anim):
	var time = parent.animation.current_animation_position
	parent.animation.play(anim)
	parent.animation.seek(time)
	
func _update_chase_animation():
	var ang = -parent.shoulder.rotation_degrees
	if ang < MAX_RIGHT:
		if parent.animation.current_animation != "walk_right":
			_set_chase_animation("walk_right")
	elif ang < MAX_UP_RIGHT:
		if parent.animation.current_animation != "walk_up_right":
			_set_chase_animation("walk_up_right")
	elif ang < MAX_UP_LEFT:
		if parent.animation.current_animation != "walk_up":
			_set_chase_animation("walk_up")
	elif ang < MAX_LEFT:
		if parent.animation.current_animation != "walk_up_left":
			_set_chase_animation("walk_up_left")
	else:
		if parent.animation.current_animation != "walk_left":
			_set_chase_animation("walk_left")
