extends StaticBody2D
class_name FarmTree

var current_time: int = 0
var completed_time: int = 0
var stages: Array = []
var player: Player
var seed_res: Resource

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var place_sprite: Sprite2D = $PlaceSprite2D
@onready var timer: Timer = $Timer

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


func setup(start_time: int, seed_name: String, key: String, hp: int):
	if not seed_name:
		return

	id = key
	HP = hp

	var sprite_frames = load("res://scenes/farm_entity/resource/" + seed_name + ".tres")
	seed_res = load("res://scenes/inventory/item/seeds/" + seed_name + ".tres")

	# Thời gian để cây trưởng thành
	completed_time = seed_res.time_range
	animated.sprite_frames = sprite_frames
	current_time = int(Time.get_unix_time_from_system() - start_time)

	setup_stages(sprite_frames)

	if current_time < 0 or current_time > completed_time:
		animated.play(str(stages.size() - 1))
	else:
		timer.start()
		animated.play(str(0))

	place_sprite.frame = 0


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
	add_product_to_inventory()
	queue_free()


func check_completed() -> bool:
	if current_time >= completed_time:
		return true
	return false


func add_product_to_inventory():
	if not seed_res.product:
		return

	for item in seed_res.product:
		InventoryEvents.emit_signal("on_add_item", item.res, item.amount)
