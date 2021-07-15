extends Node2D


var start_menu = preload("res://5. User Interfaces/Start Menu.tscn").instance()

#var player = preload("res://1. Player/Player.tscn").instance()
#var current_level = null
var prototype_level = preload("res://2. Levels/Prototype Level/Prototype Level.tscn").instance()


var current_level = null
func _ready():
	#add_child(current_level)
	goto_main_menu()
	
func goto_main_menu():
	if current_level != null:
		remove_child(current_level)
		#player.stop_camera()
	
	current_level = start_menu
	add_child(current_level)
	current_level.start_button.connect("pressed", self, "_on_Start_Button_pressed", [name])
	current_level.quit_button.connect("pressed", self, "_on_Quit_Button_pressed")
	
func _on_Start_Button_pressed(nam):
	remove_child(current_level)
	current_level = prototype_level
	add_child(current_level)
	#player = player_class
	#add_child(player)
	#player.restart(current_level.get_player_start())
	print("Start")
	#testing
	
	#start_menu.queue_free()


func _on_Quit_Button_pressed():
	get_tree().quit()
