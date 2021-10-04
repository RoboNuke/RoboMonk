extends KinematicBody2D

const DIRS = preload("res://Globals.gd").DIRS

onready var rof_timer = find_node("Rate Of Fire")
onready var vert_speed_timer = find_node("Verticle Speed")
onready var fov = find_node("FieldOfView")
onready var weapon = find_node("Fire Overlay")

enum HEIGHTS {  Lvl0, 
				Lvl1, 
				Lvl2,
				Lvl3,
				Lvl4,
				Lvl5,
				Lvl6,
				Lvl7,
				Lvl8,
				Lvl9,
				Lvl10,
				Lvl11    }
				

# State Vars
var height = HEIGHTS.Lvl0
export(DIRS) var facing_dir = DIRS.LEFT
var vert_delta = -1 if height > HEIGHTS.Lvl5 else 1
var in_warn_area = false
var in_danger_area = false

var player

# script vars
export(HEIGHTS) var max_height = HEIGHTS.Lvl11
export var can_turn_around = true


func _process(delta):
	update_fov()
	
func update_fov():
	fov.check_view()
	in_danger_area = false
	for hit in fov.in_danger_area:
		if "Player" in hit.get_groups():
			player = hit
			in_danger_area = true
			
	in_warn_area = false
	for hit in fov.in_warn_area:
		if "Player" in hit.get_groups():
			player = hit
			in_warn_area = true
	#print (in_danger_area, " ", in_warn_area)
	
func attack():
	if rof_timer.is_stopped():
		weapon.fire()
		rof_timer.start()

func search():
	if vert_speed_timer.is_stopped():
		#height += vert_delta
		if (height == max_height and vert_delta > 0) or (height == HEIGHTS.Lvl0 and vert_delta < 0):
			if height == max_height and can_turn_around:
				facing_dir = -facing_dir
			vert_delta = -vert_delta
		height+=vert_delta
			
		vert_speed_timer.start()
			
func track():
	if vert_speed_timer.is_stopped():
		if weapon.global_position.y > player.global_position.y:
			height = min(max(height + 1, 0), max_height)
		else:
			height = min(max(height - 1, 0), max_height)
		vert_speed_timer.start()
	
func can_attack():
	return rof_timer.is_stopped() and in_danger_area

func could_attack():
	return in_danger_area or in_warn_area
