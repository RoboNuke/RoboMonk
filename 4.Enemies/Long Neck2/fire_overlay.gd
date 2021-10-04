extends Sprite

onready var parent = get_parent()
onready var fov = find_node("FieldOfView")
onready var bullet_spawn = find_node("Bullet Spawn")

export(PackedScene) var bullet 
export(Texture) var bullet_texture

export var bullet_speed = 200
export var bullet_momentum = 300

func _process(delta):
	scale.x = sign(parent.facing_dir) * abs(scale.x)


func fire():
	var dir = Vector2.RIGHT if parent.facing_dir == parent.DIRS.LEFT else Vector2.LEFT
	var b = bullet.instance()
	b.set("bullet_texture", bullet_texture)
	b.set("velocity", bullet_speed)
	b.set("momentum", bullet_momentum)
	get_tree().root.add_child(b)
	b.release(bullet_spawn.global_position, dir)
