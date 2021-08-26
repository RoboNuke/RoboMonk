extends Node2D

onready var bc1 = $"Battery Cell"
onready var bc2 = $"Battery Cell2"
onready var bc3 = $"Battery Cell3"
onready var bc4 = $"Battery Cell4"
onready var glim_timer = $"Glimmer Timer"
onready var hit_timer = $"Hit Timer"

var cells = []
var color = "Green"
var kill_count = 0
var total_cells = 4
# Called when the node enters the scene tree for the first time.
func _ready():
	cells = [bc1, bc2, bc3, bc4]

func hit(body):
	if "Projectile" in body.get_groups():
		if color == "Green":
			color = "Red"
			hit_timer.start()
			for cell in cells:
				cell.player.play("Red")
		elif hit_timer.is_stopped():
			_play_deaths()
			#self.queue_free()


func _process(_delta):
	if glim_timer.is_stopped():
		_play_glimmers()
		glim_timer.start()
		
func _play_glimmers():
	for cell in cells:
		cell.play_glimmer()

func _play_deaths():
	for cell in cells:
		cell.play_death()

func kill():
	kill_count += 1
	if kill_count == total_cells:
		self.queue_free()
