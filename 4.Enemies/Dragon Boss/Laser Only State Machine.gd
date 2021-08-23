extends StateMachine

func _ready():
	active = false
	add_state("idle")
	add_state("fire_laser")
	add_state("change_side")
	add_state("losing_power")
	add_state("destroy_map")
	add_state("shutdown")
	add_state("search_player")

func start():
	active = true
	call_deferred("set_state", states.idle)
	
func _state_logic(_delta):
	#print(state)
	match state:
		states.idle:
			parent.bot_player.play("off")
			parent.top_player.play("Idle")
		states.fire_laser:
			pass
		states.change_side:
			parent._change_side()
		states.losing_power:
			pass
		states.destroy_map:
			pass
		states.shutdown:
			pass
		states.search_player:
			parent._track_player()

func _get_transition(_delta):
	match state:
		states.idle:
			return states.search_player
		states.fire_laser:
			pass
		states.change_side:
			if parent.desired_facing_dir == parent.facing_dir:
				return states.search_player
		states.losing_power:
			pass
		states.destroy_map:
			pass
		states.shutdown:
			pass
		states.search_player:
			if parent.desired_facing_dir != parent.facing_dir:
				return states.change_side
	
func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			print("Dragon Boss Init::Idling")
		states.fire_laser:
			print("Dragon Boss Init::Firing Laser")
		states.change_side:
			print("Dragon Boss Init::Changing Sides")
		states.losing_power:
			print("Dragon Boss Init::Losing Power")
		states.destroy_map:
			print("Dragon Boss Init::Destroying Map")
		states.shutdown:
			print("Dragon Boss Init::Shuting Down")
		states.search_player:
			print("Dragon Boss Init::Search Player")

func _exit_state(_old_state, _new_state):
	pass

	
