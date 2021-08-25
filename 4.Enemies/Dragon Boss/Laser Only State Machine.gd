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
			if parent.beam_cd.is_stopped() and parent.beam_rof.is_stopped():
				parent._fire_laser()
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
			if not parent.firing:
				if parent.desired_facing_dir == parent.facing_dir:
					return states.search_player
				if not parent._see_player():
					return states.search_player
				if !parent.beam_cd.is_stopped():
					return states.search_player
				
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
			if parent._see_player() and parent.beam_cd.is_stopped():
				return states.fire_laser
	
func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			print("Dragon Boss Init::Idling")
		states.fire_laser:
			print("Dragon Boss Init::Firing Laser")
			parent.firing = true
			parent.top_player.play("Fire")
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

func _exit_state(old_state, _new_state):
	match old_state:
		states.fire_laser:
			parent.top_player.play("Recoil")
			parent.top_player.queue("Idle")

	
