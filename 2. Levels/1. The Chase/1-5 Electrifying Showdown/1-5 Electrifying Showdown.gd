extends Level 

onready var first_destroy = $"Map/First Destroy"
onready var final_destroy = $"Map/Final Destroy"
onready var enter_door = $"Map/Entrance Door"
onready var exit_door = $"Map/Exit Door"
onready var boss_spawn = $"Enimies/Boss Spawn"
onready var boss_left = $"Enimies/Boss Left"
onready var boss_right = $"Enimies/Boss Right"
onready var restart_pos = $"Enimies/Boss Restart"
var init_destroyed = false

export var battery_locs = [Vector2(488,24), Vector2(488,200), Vector2(8, 152), Vector2(8, -56)]
export(PackedScene) var battery_scene 
export(PackedScene) var boss_scene

var batteries = []
var boss

func _ready():
	for pos in battery_locs:
		var b = battery_scene.instance()
		b.global_position = pos
		batteries.append(b)
		find_node("Enimies").add_child(b)
		b.connect("battery_destroyed", self, "_battery_destroyed", [b])

func _battery_destroyed(bat):
	batteries.remove(batteries.find(bat))
	bat.queue_free()
	boss.destroy_battery()
	if len(batteries) < 2:
		destroy_map()
	elif len(batteries) < 1:
		destroy_map()

func init_boss():
	boss = boss_scene.instance()
	boss.set_xs(boss_left.position.x, boss_right.position.x)
	boss.start(player, boss_spawn.global_position, restart_pos.global_position)
	boss.connect("boss_defeated", self, "_boss_death")
	add_child(boss)

func _boss_death():
	exit_door.open()
	print("Good Job")
	
func destroy_map():
	if not init_destroyed:
		first_destroy.queue_free()
		init_destroyed = true
	else:
		final_destroy.queue_free()

func _input(event):
	if event.is_action_pressed("ui_down"):
		pass

func _on_Entrance_Door_passed_through_door():
	init_boss()
	camera.start_boss_camera()
