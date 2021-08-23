extends Node2D

export(PackedScene) var boss_scene 

signal boss_action_trigger

enum ACTION_TRIGGERS {SWITCH_RIGHT=0, SWITCH_LEFT=1}

var boss_data = []

func _ready():
	boss_data.append($"Left Boss Track".position.x)
	boss_data.append($"Right Boss Track".position.x)
	
func get_player_start():
	return $"Player Start".global_position

func get_boss_start():
	return $"Boss Start".global_position
	


func _on_Left_Boss_Track_body_entered(body):
	print("left triggered")
	emit_signal("boss_action_trigger", ACTION_TRIGGERS.SWITCH_RIGHT)


func _on_Right_Boss_Track_body_entered(body):
	print("right triggered")
	emit_signal("boss_action_trigger", ACTION_TRIGGERS.SWITCH_LEFT)
