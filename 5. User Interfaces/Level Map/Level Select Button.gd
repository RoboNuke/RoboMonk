extends TextureButton

export(String) var world_name = ""
export(String) var level_name = "0-0 Prototype Level"
var level_path

func _ready():
	update_lvl_path()

func _process(_delta):
	if disabled:
		$VBoxContainer.visible = false

func _on_TextureButton_pressed():
	get_tree().change_scene_to(level_path)
	
func set_world(world : String):
	world_name = world
	
func set_level(lvl : String):
	level_name = lvl
	update_lvl_path()
	
func update_lvl_path():
	level_path = load("res://2. Levels/" + world_name + "/" + level_name + "/" + level_name + ".tscn")
	var texts = level_name.split(" ")
	$"VBoxContainer/Level Number".text = texts[0]
	$"VBoxContainer/Level Name1".text = texts[1]
	$"VBoxContainer/Level Name2".text = texts[2]
	
