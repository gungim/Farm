extends StaticBody2D
class_name Crops

var stages: Array[int] = [1,2,3,4]
var stage: int = 1
var can_harvest: bool = false

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

func _ready():
	animated.play(str(stage))

func change_state(new_state: int):
	stage = new_state
	animated.play(str(stage))

func harvest():
	if stage == stages[stages.size()-1]:
		print_debug("Harvest")

func plant():
	timer.start()
