extends Camera2D

onready var parent = get_parent()
var boss_mode = false

var h_value = 0.2
var max_x = null
var max_y = null
var min_x = null
var min_y = null
var mean_x = null
var mean_y = null
var motion_scaler = 4



func _process(_delta):
	if boss_mode:
		var ppos = parent.global_position
		global_position.x = clamp((ppos.x - mean_x)/motion_scaler + mean_x,min_x, max_x)
		global_position.y = clamp((ppos.y - mean_y)/motion_scaler + mean_y, min_y, max_y)
		
