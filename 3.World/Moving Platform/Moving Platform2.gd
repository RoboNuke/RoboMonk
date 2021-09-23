tool
extends Node2D

onready var pts = find_node("Points")
onready var player = find_node("AnimationPlayer")

export var pt2 = Vector2(0,100)
export var total_time = 4.0

func _ready():
	
	var animation = Animation.new()
	animation.length = total_time
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "KinematicBody2D:position:x")
	animation.track_insert_key(track_index, 0.0, pts.get_children()[0].position.x)
	animation.track_insert_key(track_index, total_time/2.0, pts.get_children()[1].position.x)
	print(pts.get_children()[1].position.x)
	animation.track_insert_key(track_index, total_time, pts.get_children()[0].position.x)
	
	player.add_animation("Auto", animation)

