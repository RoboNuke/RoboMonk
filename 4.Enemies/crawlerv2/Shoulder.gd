extends Position2D

onready var bullet_spawn = find_node("Bullet Spawn")
onready var parent = get_parent()

export(PackedScene) var bullet 
export(Texture) var bullet_texture

export var bullet_speed = 200
export var bullet_momentum = 300

func fire():
	var dir = (parent.player.global_position - global_position).normalized()
	var b = bullet.instance()
	b.set("bullet_texture", bullet_texture)
	b.set("velocity", bullet_speed)
	b.set("momentum", bullet_momentum)
	get_tree().root.add_child(b)
	b.release(bullet_spawn.global_position, dir)

