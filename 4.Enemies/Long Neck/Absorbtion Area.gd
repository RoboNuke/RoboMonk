extends Area2D


onready var parent = get_parent()
onready var cbox = $"Absorb Box"

func _process(_delta):
	cbox.disabled = !self.parent.moving_up
