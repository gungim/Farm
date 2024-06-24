extends StaticBody2D
class_name FarmTree

enum HarvestType { CHOP, HAND }

var current_time: int = 0
var completed_time: int = 0

var stages: Array = []
var current_state_index: int = 0

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var time_label: Label = $Label

@export var HP: int = 0
@export var harvest_type: HarvestType = HarvestType.CHOP

@export var time_label_visible: bool = false
@export var can_harvest: bool = false


func _ready():
	input_pickable = false
	time_label.visible = time_label_visible
	_help_ready()


func _help_ready():
	pass


# Stages là 1 mảng int, là thơi gian các giai đoạn phát triển của cây
# Được tạo thành nhờ số lượng animations trong sprite_frames
# Sử dụng để tính animation sẽ chạy, ...
func setup_stages(crop: Crop):
	var anm_amount = crop.sprite_frames.animations

	for i in anm_amount.size() - 1:
		var value = completed_time * i / float(anm_amount.size())
		stages.push_back(value)

	stages.push_back(completed_time)


func setup(start_time: int, crop: Crop, hp: int):
	if not crop:
		return

	HP = hp

	animated.sprite_frames = crop.sprite_frames

	# setup time
	completed_time = crop.completed_time
	current_time = int(Time.get_unix_time_from_system() - start_time)

	setup_stages(crop)

	if current_time < 0 or current_time > completed_time:
		can_harvest = true
		animated.play(str(stages.size() - 1))
	else:
		while true:
			if current_state_index == stages.size():
				break
			if current_time >= stages[current_state_index]:
				break
			else:
				current_state_index += 1

		timer.start()
		animated.play(str(0))


func _on_timer_timeout():
	current_time += 1

	if current_state_index == stages.size():
		time_label.visible = false
		can_harvest = true
		timer.stop()
	elif current_time >= stages[current_state_index]:
		current_state_index += 1

	animated.play(str(current_state_index))
	time_label.text = GlobalEvents.format_time(completed_time - current_time)


func harvest(dmg: int):
	_harvest(dmg)


func _harvest(_dmg: int):
	pass


func kill():
	owner.harvested()
	await get_tree().create_timer(2.).timeout
	queue_free()

