extends Node


export var TILE_WIDTH = 16


export(PackedScene) var main_menu_scene = preload("res://5. User Interfaces/Start Menu/Start Menu.tscn")

func pause_game():
	get_tree().paused = true
	print("Globals::Paused")
	
func unpause_game():
	get_tree().paused = false
	print("Globals::UnPaused")
