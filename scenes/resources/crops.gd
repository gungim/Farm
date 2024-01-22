extends StaticBody2D
class_name Crop

var id: String = "{}{}"

var can_harvest: bool = false

# Unit seconds
# min=0
var completed_time: int
var current_time: int = 0
var harvest_action

# [0, 15, 30, 45]
var stages: Array = []

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var time_label: Label = $Label


func _ready():
	time_label.visible = false


# @params
# start_time: thời gian trồng
# seed_item: Hạt giống
# sprite_frames: animation của hạt giống
func setup(start_time: int, time_range: int, sprite_frames: SpriteFrames, action):
	harvest_action = action
	animated.sprite_frames = sprite_frames
	completed_time = time_range
	current_time = int(Time.get_unix_time_from_system() - start_time)

	var anm_amount = sprite_frames.animations

	for i in anm_amount.size() - 1:
		var value = completed_time * i / anm_amount.size()
		stages.push_back(value)
	stages.push_back(time_range)

	if current_time < 0 or current_time > completed_time:
		time_label.text = format_time(completed_time - current_time)
		animated.play(str(stages.size() - 1))
	else:
		timer.start()
		animated.play(str(0))


func _on_timer_timeout():
	current_time += 1
	time_label.text = format_time(completed_time - current_time)

	if current_time > stages[-1]:
		animated.play(str(stages.size() - 1))
		time_label.text = ""
		timer.stop()
	elif current_time <= stages[1]:
		animated.play(str(0))
	else:
		for i in range(1, stages.size()):
			if current_time <= stages[i]:
				animated.play(str(i - 1))
				break


func format_time(secs: int) -> String:
	var hours = floor(secs / float(60 * 60))
	var divisor_for_minutes = secs % (60 * 60)
	var minutes = floor(divisor_for_minutes / float(60))
	var divisor_for_seconds = divisor_for_minutes % 60
	var seconds = ceil(divisor_for_seconds)

	hours = hours if hours >= 10 else "0" + str(hours)
	minutes = minutes if minutes >= 10 else "0" + str(minutes)
	seconds = seconds if seconds >= 10 else "0" + str(seconds)

	return "{0}:{1}:{2}".format([hours, minutes, seconds])


func _on_mouse_entered():
	print_debug("Enter")
	time_label.visible = true


func _on_mouse_exited():
	await get_tree().create_timer(3.).timeout
	time_label.visible = false


func harvest():
	print_debug("Harvest")


func chop():
	print_debug("Chop")

func kill():
	queue_free()
