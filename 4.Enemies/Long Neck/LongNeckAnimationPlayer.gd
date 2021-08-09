tool
extends AnimationPlayer

# Called when the node enters the scene tree for the first time.

onready var sprite = get_parent().get_node("Sprite")
onready var cbox = get_parent().get_node("CollisionShape2D")

var TOTAL_FRAMES = 24
#var timer
var INIT_CBOX_HEIGHT = 5
var CBOX_WIDTH = 6.5
func _ready():
	for i in range(TOTAL_FRAMES):
		var new_anim = Animation.new()
		var frame_count = int((i - i%2)/2)
		if i % 2 == 0:
			self.add_animation("Left_" + str(frame_count), new_anim)
		else:
			self.add_animation("Right_" + str(frame_count), new_anim)
		
		new_anim.add_track(0)
		new_anim.add_track(0)
		new_anim.add_track(0)
		new_anim.length = 0.25
		
		var path = String(sprite.get_path()) + ":frame"
		new_anim.track_set_path(0, path)
		new_anim.track_insert_key(0,0,i)
		path = String(cbox.get_path()) + ":shape:extents:y"
		new_anim.track_set_path(1, path)
		new_anim.track_insert_key(1,0, INIT_CBOX_HEIGHT + frame_count)
		path = String(cbox.get_path()) + ":position:y"
		new_anim.track_set_path(2, path)
		new_anim.track_insert_key(2,0, -(INIT_CBOX_HEIGHT + i/2))
	
	


