extends Camera2D

onready var parent = get_parent()
onready var player = get_parent().find_node("Player")
onready var far_pt = get_parent().find_node("Farthest Point")

var projectResolution = Vector2(640,360)

var max_x 

func _ready():
	max_x = far_pt.global_position.x

func _process(delta):
	if player.position.y < 50:
		global_position.y = -160
	else:
		global_position.y = 0
	global_position.x = max(parent.player.global_position.x - projectResolution.x/2, 0)
	global_position.x = min(global_position.x, max_x)
	
