extends StateMachine

var in_fire_queue = false

func _ready():
	active = false
	add_state("idle")
	add_state("fire_laser")
	add_state("change_side")
	add_state("losing_power")
	add_state("destroy_map")
	add_state("shutdown")
	add_state("search_player")
	add_state("fire_ball")
	add_state("ping_pong_above")

func start():
	active = true
	call_deferred("set_state", states.idle)
	
	
func _state_logic(_delta):
	#print(state)
	match state:
		states.idle:
			parent.bot_player.play("off")
			parent.top_player.play("Idle")
		states.search_player:
			parent._track_player()
			if parent.move_dir == parent.MOVE_DIRS.DOWN:
				parent.bot_player.play("high")
			elif parent.move_dir == parent.MOVE_DIRS.UP:
				parent.bot_player.play("Fly Down")
			else:
				parent.bot_player.play("Idle")
		states.fire_laser:
			if parent.beam_cd.is_stopped() and parent.beam_rof.is_stopped():
				parent._fire_laser()
		#states.fire_ball:
			#if parent.ball_cd.is_stopped() and parent.ball_rof.is_stopped():
			#	parent._fire_ball()
		#	pass
		states.change_side:
			parent._change_side()
		states.destroy_map:
			parent._destroy_map()
		states.shutdown:
			parent._shutdown()
		states.ping_pong_above:
			parent._ping_pong_above()
			print("in fire que: ", in_fire_queue)
			print("current_anim: ", parent.bot_player.current_animation)
			if not in_fire_queue and parent.bot_player.current_animation == "Idle":
				print("starting fire queue")
				parent.bot_player.play("low_open")
				parent.bot_player.queue("low_gun")
				parent.bot_player.queue("low_fire")
				in_fire_queue = true
		states.losing_power:
			pass



func _on_Bottom_Player_animation_finished(anim_name):
	print(anim_name, " has finished playing")
	if anim_name == "low_gun" and parent.firing_balls:
		parent.bot_player.play("low_close")
	if anim_name == "low_close" and parent.firing_balls:
		parent.firing_balls = false
		in_fire_queue = false
		parent.bot_player.play("Idle")
		
func _get_transition(_delta):
	match state:
		states.idle:
			return states.search_player
		states.search_player:
			if parent.shutdown:
				return states.shutdown
			if parent.desired_facing_dir != parent.facing_dir:
				return states.change_side
			if parent._see_player() and parent.beam_cd.is_stopped():
				return states.fire_laser
			if parent.destroying_map and not parent.map_destroyed:
				return states.destroy_map
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
			if not parent.destroying_map:
				return states.search_player
		states.shutdown:
			if parent.phase == parent.PHASES.FINAL:
				return states.ping_pong_above
		states.ping_pong_above:
			pass
			#if parent.ball_cd.is_stopped():
			#	return states.fire_ball
		states.fire_ball:
			if parent.firing_balls:
				return states.ping_pong_above
		
	
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
		states.fire_ball:
			print("Dragon Boss Init::Fire Ball")
			parent.firing_balls = true
		states.ping_pong_above:
			print("Dragon Boss Init::Ping Pong Above")

func _exit_state(old_state, _new_state):
	match old_state:
		states.fire_laser:
			parent.top_player.play("Recoil")
			parent.top_player.queue("Idle")
			

	

