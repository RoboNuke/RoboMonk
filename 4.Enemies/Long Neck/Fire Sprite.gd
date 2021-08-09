extends Sprite

onready var parent = get_parent()

export var X_OFFSET = 5.5
export var MIN_Y_OFFSET = -5.5
enum FACE_DIRS {LEFT=0, RIGHT=1}
enum HEIGHTS {lvl_0 = 0, lvl_1 = 1, lvl_2 = 2, lvl_3 = 3,lvl_4 = 4,lvl_5 = 5,lvl_6 = 6,lvl_7 = 7,lvl_8 = 8,lvl_9 = 9,lvl_10 = 10,lvl_11 = 11}

var current_lvl = HEIGHTS.lvl_0

var current_x = -X_OFFSET

func _process(delta):
	if parent.desired_facing_dir == FACE_DIRS.LEFT and current_x > 0:
		current_x = -X_OFFSET
		position.x = current_x
	elif parent.desired_facing_dir == FACE_DIRS.RIGHT and current_x < 0:
		current_x = abs(X_OFFSET)
		position.x = current_x
		
	if current_lvl != parent.current_height:
		current_lvl = parent.current_height
		position.y = MIN_Y_OFFSET - 2 * current_lvl
	
	

