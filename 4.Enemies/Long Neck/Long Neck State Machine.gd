extends StateMachine

var anim_prefex = ["Right_", "Left_"]
func _ready():
	add_state("search")
	add_state("attack")
	call_deferred("set_state", states.search)
	
func _state_logic(_delta):
	var prefex = "Left_" if parent.desired_facing_dir == parent.FACE_DIRS.LEFT else "Right_"
	if state == states.search:
		parent._search()
		if !parent.animation.is_playing():
			parent.animation.play(prefex + str(parent.current_height))
			
	elif state == states.attack:
		if parent.rof.is_stopped():
			parent.animation_fire.play(prefex + "Fire")
		if !parent.animation.is_playing():
			parent.animation.play(prefex+str(parent.current_height))

func _get_transition(_delta):
	match state:
		states.search:
			if parent.see_player:
				return states.attack
				
		states.attack:
			if !parent.see_player:
				return states.search
			
	
func _enter_state(new_state, _old_state):
	var prefex = "Left_" if parent.desired_facing_dir == parent.FACE_DIRS.LEFT else "Right_"
	match new_state:
		states.search:
			parent.animation.play(prefex + str(parent.current_height))
		states.attack:
			parent._attack()
			parent.animation.play(prefex+str(parent.current_height))

func _exit_state(_old_state, _new_state):
	pass

func _on_AnimationPlayer_animation_finished(_anim_name):
	if state == states.attack:
		return
	if state == states.search:
		parent._search_step()
		var prefex = "Left_" if parent.facing_dir == parent.FACE_DIRS.LEFT else "Right_"
		parent.animation.play(prefex + str(parent.current_height))
	
