extends StateMachine
var MAX_RIGHT = 45/2
var MAX_UP_RIGHT = 45/2 + 45
var MAX_UP = 45/2 + 90
var MAX_UP_LEFT = 180 - 45/2
var MAX_LEFT = 180+45/2

var anim_ranges = [MAX_RIGHT, MAX_UP_RIGHT, MAX_UP, MAX_UP_LEFT, MAX_LEFT]
var anim_names = ["_right", "_up_right", "_up", "_up_left", "_left"]
func _ready():
	add_state("idle")
	add_state("search")
	add_state("walk_search")
	add_state("chase")
	add_state("attack")
	call_deferred("set_state", states.search)
	
func _state_logic(_delta):
	
	if state == states.search:
		parent._search()
	elif state == states.walk_search:
		parent._walk_search()
	elif state == states.chase:
		if parent.can_move:
			parent._chase()
		_update_directional_animation()
	elif state == states.attack:
		if parent._attack():
			_update_directional_animation("fire")
	elif state == states.idle:
		parent._idle()
	
func _get_transition(_delta):
	var player_in_fov = parent._check_fov()
	match state:
		states.search:
			if player_in_fov[0]: # in danger zone
				return states.attack
			elif player_in_fov[1]:
				return states.chase
		states.chase:
			if player_in_fov[0] and parent.animation.get_current_animation()[0] != 'f' and parent.rof.is_stopped():
				return states.attack
			elif player_in_fov[0] and parent.animation.get_current_animation()[0] != 'f':
				return null 
			elif !(player_in_fov[1]):
				return states.search
				
		states.attack:
			if player_in_fov[1]:
				return states.chase
			elif player_in_fov[0] and !parent.animation.is_playing() and !parent.rof.is_stopped():
				# can still see player and have finished firing but the weapon on cd
				return states.chase
			elif !player_in_fov[0]:
				return states.search
			
	
func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			parent.animation.play("idle")
		states.search:
			parent.animation.play("search 3")
		states.chase:
			_update_directional_animation()
		states.attack:
			#_update_directional_animation()
			_update_directional_animation("fire")

func _exit_state(old_state, _new_state):
	if old_state == states.search:
		parent.animation.stop()
	pass

func _set_direction_animation(anim, on_beat=true):
	var time = 0
	if parent.animation.is_playing():
		time = parent.animation.current_animation_position
	parent.animation.play(anim)
	if on_beat:
		parent.animation.seek(time)

func _get_anim_idx():
	var ang = -parent.shoulder.rotation_degrees
	for i in range(len(anim_ranges)):
		if ang < anim_ranges[i]:
			return(i)
	return(-1)
	
func _track_animation():
	var idx = _get_anim_idx()
	if !parent.animation.is_playing():
		parent.animation.play("fire"+anim_names[idx])
		parent.animation.seek(parent.animation.current_animation_length)
	
func _update_directional_animation(type="walk"):
	var idx = _get_anim_idx()
	var on_beat = not (type=="fire")
	if parent.animation.current_animation != type+anim_names[idx]:
		_set_direction_animation(type+anim_names[idx], on_beat)
