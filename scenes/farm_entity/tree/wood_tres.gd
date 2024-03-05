extends StaticBody2D
class_name WoodTree

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

@export var id: String

var current_time: int = 0

var stages: Array = []


func _ready():
	input_pickable = true


func setup(start_time: int, seed_name: String):
	if not seed_name:
		return

	var sprite_frames = load("res://scenes/farm_entity/resource/" + seed_name + ".tres")
	var seed_res = load("res://scenes/inventory/item/seeds/" + seed_name + ".tres")
	# Thời gian để cây trưởng thành
	var completed_time = seed_res.time_range

	animated.sprite_frames = sprite_frames
	current_time = int(Time.get_unix_time_from_system() - start_time)

	var anm_amount = sprite_frames.animations

	for i in anm_amount.size() - 1:
		var value = completed_time * i / float(anm_amount.size())
		stages.push_back(value)
	stages.push_back(seed_res.time_range)

	if current_time < 0 or current_time > completed_time:
		animated.play(str(stages.size() - 1))
	else:
		timer.start()
		animated.play(str(0))


func _on_timer_timeout():
	current_time += 1

	if current_time > stages[-1]:
		animated.play(str(stages.size() - 1))
		timer.stop()
	elif current_time <= stages[1]:
		animated.play(str(0))
	else:
		for i in range(1, stages.size()):
			if current_time <= stages[i]:
				animated.play(str(i - 1))
				break


func harvest():
	pass


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed :
			print(event)
