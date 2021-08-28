extends Node2D

onready var door_player = $"Boss Trigger/Door Player"
onready var door_collision = $"Door Stopper/Door Stopper Collision"
onready var boss_destroy_tilemap = $"Map/Boss Destroy TileMap"
onready var boss_final_destroy_tilemap = $"Map/Boss Final Destroy TileMap"
onready var restart_pos = $"Boss Restart"
export(PackedScene) var boss_scene 

signal boss_action_trigger
var boss
enum ACTION_TRIGGERS {SWITCH_RIGHT=0, SWITCH_LEFT=1, DESTROY_BATTERY=2}

var boss_data = []
var init_destroyed = false
export var boss_camera_dict = {'mean x':1280, 'mean y':80, 'max x':1700, 'max y':80, 'min x':1250, 'min y':80,'motion scaler':4,"h value":0.1, "restart":Vector2(1520,80)}

func _ready():
	boss_data.append($"Left Boss Track".position.x)
	boss_data.append($"Right Boss Track".position.x)
	door_player.play("Opened")
	#door_collision.disabled = true
	
func get_player_start():
	return $"Player Start".global_position

func get_boss_start():
	return $"Boss Start".global_position

	
func spawn_boss():
	door_player.play("Closed")

func connect_boss(bos):
	boss = bos
	boss.connect("destroy_map", self, "destroy_map")
	print(boss_destroy_tilemap)

func destroy_map():
	if init_destroyed:
		boss_final_destroy_tilemap.queue_free()
	else:
		boss.restart_pos = restart_pos.global_position
		boss_destroy_tilemap.queue_free()
		init_destroyed = true
	
func _on_Left_Boss_Track_body_entered(body):
	print("left triggered")
	emit_signal("boss_action_trigger", ACTION_TRIGGERS.SWITCH_RIGHT)

func _on_Right_Boss_Track_body_entered(body):
	print("right triggered")
	emit_signal("boss_action_trigger", ACTION_TRIGGERS.SWITCH_LEFT)

func _on_Battery_battery_destroyed():
	emit_signal("boss_action_trigger", ACTION_TRIGGERS.DESTROY_BATTERY)

func _on_Battery2_battery_destroyed():
	emit_signal("boss_action_trigger", ACTION_TRIGGERS.DESTROY_BATTERY)

func _on_Battery3_battery_destroyed():
	emit_signal("boss_action_trigger", ACTION_TRIGGERS.DESTROY_BATTERY)
