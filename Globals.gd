extends Node


export var TILE_WIDTH = 16

export(PackedScene) var main_menu_scene = preload("res://5. User Interfaces/Start Menu/Start Menu.tscn")
export(PackedScene) var level_select_scene = preload("res://5. User Interfaces/Level Map/Level Map.tscn")
export(PackedScene) var win_level_screen = preload("res://5. User Interfaces/Win Screen/Win Screen.tscn")
export(PackedScene) var save_menu_scene = preload("res://5. User Interfaces/Save Game Menu/Save Game Menu.tscn")

var game_data_path = "res://2. Levels/Level Metadata.json"


var player_name
var worlds 
var levels 
var level
var world
var unlocked = []

var bg_player = null
var timer = null
var music_idx = 0
var bg_musics

var fx_volume = -16
var music_volume = -16


#useful enums
enum DIRS {LEFT=-1, NONE=0, RIGHT=1}

# global constants
var FLOOR_NORMAL = Vector2.UP
var IDLE_CUTOFF = 1.5


func add_ui_music(a,b,c):
	bg_musics = [a,b,c]
	

func start_bg_music():
	print("Called")
	if bg_player == null:
		bg_player = AudioStreamPlayer.new()
		add_child(bg_player)
		bg_player.bus = "master"
		bg_player.volume_db = -24
		
	bg_player.stream = bg_musics[music_idx]
	music_idx = (music_idx + 1) % 3
	bg_player.play()
	
	if timer == null:
		timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 100
		add_child(timer)
		timer.connect("timeout", self, "start_bg_music")
		
	timer.start()
	
func stop_bg_music():
	if bg_player != null:
		bg_player.playing = false
		timer.stop()

func _ready():
	for i in range(5):
		unlocked.append([])
		for j in range(5):
			unlocked[i].append(false)

func save_game():
	var save_data = _get_save_data()
	_write_json_data(game_data_path, save_data)

func _get_save_data():
	var save_data = []
	save_data.append(worlds)
	#check for unlock and mark appropriately 
	for i in range(5):
		for j in range(5):
			if !unlocked[i][j]:
				levels[i][j] = "#" + levels[i][j]
	save_data.append(levels)
	save_data.append(player_name)
	return save_data

func unlock_level(world:int, level:int):
	unlocked[world][level] = true
	save_game()

func set_level(level_name:String):
	
	world = int(level_name[0]) - 1
	level = int(level_name[2]) - 1
	
	print("World ", world, " at Level: ", level)

func pause_game():
	get_tree().paused = true
	print("Globals::Paused")
	
func unpause_game():
	get_tree().paused = false
	print("Globals::UnPaused")

func _write_json_data(filepath:String, data):
	var file = File.new()
	file.open(filepath, file.WRITE)
	file.store_line(to_json(data))
	file.close()
