extends Control

export (PackedScene) var base_button
export (int) var total_levels = 25
export (NodePath) var grid

var worlds
var levels

func _ready():
	grid = get_node(grid)
	
	var file = File.new()
	file.open("res://2. Levels/Level Metadata.json", file.READ)
	var json = file.get_as_text()
	var jdata = parse_json(json)
	worlds = jdata[0]
	levels = jdata[1]
	
	#if !total_levels <= 4:
	#	column_size()
	
	grid.columns = 5
	
	for i in range(1):
		for j in range(5):
			generate_buttons(worlds[i], levels[i][j])


func generate_buttons(world : String, name : String):
	var bb = base_button.instance()
	bb.set_world(world)
	bb.set_level(name)
	grid.add_child(bb)


func column_size():
	if total_levels % 2 == 0:
		grid.columns = total_levels/2
	else:
		grid.columns = total_levels/2 + 1
