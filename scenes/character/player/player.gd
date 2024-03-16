extends CharacterBody2D
class_name Player

# Signal được phát khi HP của player bị thay đổi
signal updated_hp

# using to check player can farm

var farm_state = null
var current_slot_selected: Slot
var mov_direction: Vector2 = Vector2.ZERO
var FRICTION = 0.15

@export var MAX_SPEED = 100
@export var MAX_HP = 100
@export var ACCELERATION = 40
@export var HP: int = 10

@onready var equipment: Equipment = $Equipment
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var state: StateChart = $StateChart
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	PlayerEvents.connect("on_use_item", _on_use_item)
	PlayerEvents.connect("on_hold_item", _on_hold_item)


func get_input():
	mov_direction = Input.get_vector("left", "right", "up", "down")


func _process(_delta):
	get_input()

	if mov_direction != Vector2.ZERO:
		move()

	if velocity <= Vector2.ZERO:
		animated.flip_h = true
	else:
		animated.flip_h = false


# Sử dụng tương tự hàm move
func move_to_target():
	var next_path = agent.get_next_path_position()

	var new_dir: Vector2 = global_position.direction_to(next_path)

	if agent.avoidance_enabled:
		agent.set_velocity(velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(velocity)

	if agent.is_navigation_finished():
		mov_direction = Vector2.ZERO
		return
	mov_direction = new_dir


func change_hp(value: int):
	HP += value
	if HP >= MAX_HP:
		HP = MAX_HP
	updated_hp.emit(HP)


func hold_item():
	equipment.update_item(current_slot_selected)


func update_equipment_item():
	if current_slot_selected.amount <= 0:
		current_slot_selected = null
		equipment.update_item(current_slot_selected)


func eat_food():
	var properties = current_slot_selected.item.properties

	if HP < MAX_HP:
		change_hp(properties.healing)
		current_slot_selected.amount -= 1
		update_equipment_item()


# using when click on hotbar
func _on_use_item(slot: Slot):
	if slot and slot.item:
		var action = slot.item
		match action:
			GlobalEvents.product_actions.FOOD:
				eat_food()


func _on_hold_item(slot: Slot):
	current_slot_selected = slot
	if slot and slot.item is SeedItem:
		hold_item()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	mov_direction = safe_velocity


func _on_movement_state_physics_processing(_delta):
	var target_pos = agent.get_next_path_position()
	if position.distance_to(target_pos) >= 32:
		mov_direction = target_pos - global_position
		move()
	else:
		state.send_event("navigation_finished")


func move():
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * ACCELERATION
	velocity = velocity.limit_length(MAX_SPEED)
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	move_and_slide()


func _on_chop_state_entered():
	var item = current_slot_selected.item
	var damage = item.properties["damage"]
	var dmg: int = randi_range(damage - 2, damage + 2)
	FarmEvents.emit_signal("on_chop", dmg)


func using_item():
	if not current_slot_selected:
		return
	var item = current_slot_selected.item
	if not item:
		return

	if item is ProductionItem:
		var actions = item.action
		if actions[0] == GlobalEvents.product_actions.BUILD:
			FarmEvents.emit_signal("on_build_barn")
	elif item is SeedItem:
		FarmEvents.emit_signal("on_plant", current_slot_selected)
		update_equipment_item()

	elif item is ToolItem:
		var action = item.action
		match action:
			GlobalEvents.tool_actions.HOE:
				FarmEvents.emit_signal("on_hoe")
			GlobalEvents.tool_actions.WATERING:
				FarmEvents.emit_signal("on_watering")
			GlobalEvents.tool_actions.HARVEST:
				FarmEvents.emit_signal("on_harvest")
			GlobalEvents.tool_actions.CHOP:
				var dmg = item.properties["damage"]
				FarmEvents.emit_signal("on_chop", dmg)


func check_farm_state(key: String) -> int:
	if not current_slot_selected:
		return -1
	var item = current_slot_selected.item
	if not item:
		return -1
	if not item is ToolItem:
		return -1

	var tool_action = item.action

	match key:
		"chop":
			if tool_action == GlobalEvents.tool_actions.CHOP:
				return item.properties.get("damage")
			return -1
		_:
			return -1

func play_animation(animation_name):
	pass
	animated.play(animation_name)

func cancel_farm():
	animated.stop()
