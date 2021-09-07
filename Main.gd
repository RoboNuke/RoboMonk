extends Node2D

onready var boss_timer = $"Boss Defeated"
onready var dialog_player = $"Dialog Player"

# Packed Scenes
export(PackedScene) var start_menu_scene = preload("res://5. User Interfaces/Start Menu.tscn")#.instance()
export(PackedScene) var player_scene = preload("res://1. Player/Player.tscn")
#export(PackedScene) var prototype_level_scene = preload("res://2. Levels/Prototype Level/Prototype Level.tscn")
export(PackedScene) var prototype_level_scene = preload("res://2. Levels/1.1 Underground Escape/1-1 Underground Escape.tscn")
var current_level
var player
var boss
var boss_spawned = false

func _ready():
	#add_child(current_level)
	#goto_main_menu()
	_on_Start_Button_pressed(1)
func goto_main_menu():
	if current_level != null:
		boss_spawned = false
		remove_child(boss)
		if is_instance_valid(boss):
			boss.queue_free()
		remove_child(current_level)
		current_level.queue_free()
		remove_child(player)
		player.queue_free()
	
	current_level = start_menu_scene.instance()

	add_child(current_level)
	current_level.start_button.connect("pressed", self, "_on_Start_Button_pressed", [name])
	current_level.quit_button.connect("pressed", self, "_on_Quit_Button_pressed")
		

func _load_level(level=prototype_level_scene):
	if current_level != null:
		current_level.queue_free()
	current_level = prototype_level_scene.instance()
	add_child(current_level)
	#current_level.get_node("Boss Trigger").connect("body_entered",self, "_boss_triggered")
	#current_level.connect("boss_action_trigger",self, "_trigger_boss_action")

func _add_player():
	player = player_scene.instance()
	add_child(player)
	player.restart(current_level.get_player_start())
	player.connect("player_killed", self, "_on_player_death")
	current_level.player = player
	
	
func _on_Start_Button_pressed(_nam):
	remove_child(current_level)
	_load_level()
	_add_player()
	#dialog_player.play_dialog("Game_Start")
	#call_deferred("_pause_game")
	
func _pause_game():
	get_tree().paused = true
	
func _on_player_death():
	#remove_child(player)
	goto_main_menu()
	#player.restart(current_level.get_player_start())
	
func _trigger_boss_action(action):
	print(boss)
	if is_instance_valid(boss):
		boss.trigger_action(action)
	
func _init_boss():
	add_child(boss)
	boss.player = player
	boss.start(current_level.get_boss_start())
	current_level.connect_boss(boss)
	boss.set_boss_data(current_level.boss_data)
	boss.connect("boss_defeated", self, "_boss_defeat")
	player.set_camera_params(current_level.boss_camera_dict)
	#current_level.start_boss_camera()

func _boss_triggered(_body):
	if boss_spawned:
		return
	boss_spawned = true
	boss = current_level.boss_scene.instance()
	current_level.spawn_boss()
	call_deferred("_init_boss")

func _boss_defeat():
	boss_timer.start()


func _on_Quit_Button_pressed():
	get_tree().quit()


func _on_Boss_Defeated_timeout():
	#current_level.queue_free()
	goto_main_menu()


func _on_Dialog_Player_dialog_complete():
	#get_tree().paused = true
	#_load_level()
	#_add_player()
	current_level.rumble()
	get_tree().paused = false
	_add_player()
	
