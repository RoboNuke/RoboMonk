extends Level


func _ready():
	fall_dist = 272-24-Globals.TILE_WIDTH
	#print("Fall Dist:", fall_dist)
	player.set_fall_dist(fall_dist)

func _on_Player_player_killed():
	player_death()

func _on_Win_Area_body_entered(_body):
	print("Won in 1.2")
	player_win()
