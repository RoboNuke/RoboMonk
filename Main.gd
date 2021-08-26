extends Node2D


onready var main_bg = $ParallaxBackground/ParallaxLayer/MainBG

# backgrounds
var scifi_bg = preload("res://2. Levels/Backgrounds/scifi_platform_BG1.jpg")

# Packed Scenes
export(PackedScene) var start_menu_scene = preload("res://5. User Interfaces/Start Menu.tscn")#.instance()
export(PackedScene) var player_scene = preload("res://1. Player/Player.tscn")
export(PackedScene) var prototype_level_scene = preload("res://2. Levels/Prototype Level/Prototype Level.tscn")

var current_level
var player
var boss
var boss_spawned = false

func _ready():
	#add_child(current_level)
	goto_main_menu()
	
func goto_main_menu():
	if current_level != null:
		remove_child(current_level)
		remove_child(player)
		player.stop_camera()
	
	current_level = start_menu_scene.instance()

	add_child(current_level)
	current_level.start_button.connect("pressed", self, "_on_Start_Button_pressed", [name])
	current_level.quit_button.connect("pressed", self, "_on_Quit_Button_pressed")
		
	
func _on_Start_Button_pressed(_nam):
	main_bg.texture = scifi_bg
	remove_child(current_level)
	current_level = prototype_level_scene.instance()
	add_child(current_level)
	current_level.get_node("Boss Trigger").connect("body_entered",self, "_boss_triggered")
	current_level.connect("boss_action_trigger",self, "_trigger_boss_action")
	#player = player_class
	player = player_scene.instance()
	add_child(player)
	player.restart(current_level.get_player_start())
	player.connect("player_killed", self, "_on_player_death")
	print("Start")
	#testing
	
	#start_menu.queue_free()
func _on_player_death():
	#remove_child(player)
	#goto_main_menu()
	player.restart(current_level.get_player_start())
	
func _trigger_boss_action(action):
	if boss != null:
		boss.trigger_action(action)
	
func _init_boss():
	add_child(boss)
	boss.player = player
	boss.start(current_level.get_boss_start())
	boss.set_boss_data(current_level.boss_data)
	
func _boss_triggered(_body):
	if boss_spawned:
		return
	boss_spawned = true
	boss = current_level.boss_scene.instance()
	current_level.spawn_boss()
	call_deferred("_init_boss")
	
func _on_Quit_Button_pressed():
	get_tree().quit()
