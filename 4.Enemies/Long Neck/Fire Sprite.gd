extends Sprite

onready var parent = get_parent()
onready var fov = $FieldOfView

export var X_OFFSET = 5.5
export var MIN_Y_OFFSET = -5.5
enum FACE_DIRS {LEFT=0, RIGHT=1}
enum HEIGHTS {lvl_0 = 0, lvl_1 = 1, lvl_2 = 2, lvl_3 = 3,lvl_4 = 4,lvl_5 = 5,lvl_6 = 6,lvl_7 = 7,lvl_8 = 8,lvl_9 = 9,lvl_10 = 10,lvl_11 = 11}

var current_lvl = HEIGHTS.lvl_0

func _ready():
	position.x = -X_OFFSET
	fov.position.x = 0
func _process(_delta):
	if parent.facing_dir == FACE_DIRS.LEFT and position.x > 0:
		position.x = -X_OFFSET
		fov.rotation_degrees = -180
		flip_h = false
	elif parent.facing_dir == FACE_DIRS.RIGHT and position.x < 0:
		position.x = abs(X_OFFSET)
		fov.rotation_degrees = 0
		
		flip_h = true
	if current_lvl != parent.current_height:
		current_lvl = parent.current_height
		position.y = MIN_Y_OFFSET - 2 * current_lvl
	
	

