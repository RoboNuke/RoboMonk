extends Node2D


func _flip_h(child = self):
	if child != self:
		child.flip_h = !child.flip_h
	if child.get_child_count() > 0:
		for chil in child.get_children():
			_flip_h(chil)
