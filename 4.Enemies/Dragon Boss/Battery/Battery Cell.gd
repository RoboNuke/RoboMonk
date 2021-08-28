extends StaticBody2D

onready var parent = get_parent()
onready var player = $AnimationPlayer

func play_glimmer():
	player.play(parent.color)
	
func hit(body):
	parent.hit(body)
	
func play_death():
	player.play("Boom")
	
func die():
	print("I'm dying")
	parent.kill()
