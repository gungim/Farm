extends StaticBody2D
class_name FarmTree

var current_time: int = 0
var completed_time: int = 0

var stages: Array = []
var current_state_index: int = 0

var player: Player
var seed_res: Resource

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var time_label: Label = $Label

@export var id: String
@export var HP: int = 0


func _ready():
	input_pickable = true
	player = get_tree().get_first_node_in_group("Player")
	_setup()


func _setup():
	pass


# Stages là 1 mảng int, là thơi gian các giai đoạn phát triển của cây
# Được tạo thành nhờ số lượng animation trong sprite_frames
# Sử dụng để tính animation sẽ chạy, ...
func setup_stages(
	sprite_frames: SpriteFrames,
):
	var anm_amount = sprite_frames.animations

	for i in anm_amount.size() - 1:
		var value = completed_time * i / float(anm_amount.size())
		stages.push_back(value)
	stages.push_back(completed_time)


# TODO: chức năng trồng cây
func setup(start_time: int, item: InventoryItem, hp: int):
	if not item:
		return

	HP = hp
	seed_res = item

	# setup animation
	var sprite_name = seed_res.name.get_slice("_", 1)
	var sprite_frames: SpriteFrames = load(
		"res://scenes/farm_entity/resource/" + sprite_name + ".tres"
	)
	animated.sprite_frames = sprite_frames

	# setup time
	completed_time = seed_res.properties["completed_time"]
	current_time = int(Time.get_unix_time_from_system() - start_time)

	setup_stages(sprite_frames)

	if current_time < 0 or current_time > completed_time:
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
	print_debug(stages)


func _on_timer_timeout():
	current_time += 1

	if current_state_index == stages.size():
		time_label.visible = false
		timer.stop()
	elif current_time >= stages[current_state_index]:
		current_state_index += 1

	animated.play(str(current_state_index))
	time_label.text = GlobalEvents.format_time(completed_time - current_time)


func _harvest():
	pass


func _mouse_right_event():
	pass


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if player.position.distance_to(global_position) <= 64:
			if event.button_index == MOUSE_BUTTON_LEFT:
				_harvest()
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				_mouse_right_event()


func kill():
	FarmEvents.emit_signal("on_harvested", id)
	player.cancel_farm()
	_add_product_to_inventory()
	queue_free()


func check_completed() -> bool:
	if current_time >= completed_time:
		return true
	return false


func _add_product_to_inventory():
	pass
