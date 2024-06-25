# FIX dev
extends AppCharacter
class_name Player

# using to check player can farm

var farm_state = null
var current_slot: Slot
var current_slot_index: int

var can_move: bool = true

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var state: StateChart = $StateChart


func _ready():
	PlayerEvents.connect("on_use_item", _on_use_item)
	PlayerEvents.connect("on_select_hotbar_slot", _on_select_hotbar_slot)
	PlayerEvents.connect("on_disable_player", _on_disable_player)


func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_position = get_global_mouse_position()
			if position.distance_to(mouse_position) >= 32:
				agent.target_position = mouse_position
				state.send_event("place_marker_setted")
			else:
				if check_item_by_category("tool"):
					var item_action_type = get_item_property("action_type")
					match item_action_type:
						"hoe", "shovel":
							FarmEvents.emit_signal("on_hoe", mouse_position)
						_:
							pass

				elif check_item_by_category("build"):
					var construction = get_item_property("construction")
					match construction:
						"fence":
							FarmEvents.emit_signal("on_build_fence")
						"gate":
							FarmEvents.emit_signal("on_build_gate")


func change_hp(value: int):
	HP += value
	if HP >= MAX_HP:
		HP = MAX_HP
	PlayerEvents.emit_signal("on_update_hp", HP)


func _on_disable_player(value):
	can_move = !value


# ---------------------- State ----------------------------
func get_input():
	return Input.get_vector("left", "right", "up", "down")


func _on_idle_state_physics_processing(_delta: float):
	mov_direction = get_input()

	if mov_direction != Vector2.ZERO:
		move()
	# TODO: tính năng nếu gặp đối tượng và k thể di chuyển thì dừng sau 1 vài giây

	if velocity <= Vector2.ZERO:
		animated.flip_h = true
	else:
		animated.flip_h = false


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	mov_direction = safe_velocity


func _on_movement_state_physics_processing(_delta):
	var next_path = agent.get_next_path_position()
	var new_dir: Vector2 = position.direction_to(next_path)

	# Check nếu người dùng ấn nút di chuyển thì kết thúc việc di chuyển đến marker
	if get_input() != Vector2.ZERO:
		agent.target_position = position
		state.send_event("navigation_finished")

	if agent.avoidance_enabled:
		agent.set_velocity(velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(velocity)

	if agent.is_navigation_finished():
		mov_direction = Vector2.ZERO
		state.send_event("navigation_finished")
		return
	mov_direction = new_dir
	move()


#------------------------ End state ------------------


# ----------------------- Inventory -------------------
func check_item_property(key: String) -> bool:
	if not current_slot:
		return false

	if not get_item_property(key):
		return false
	return true


# Trả về -1 nếu k có category = tool.tres
func check_item_by_category(category_name: String) -> bool:
	if not current_slot:
		return false
	var item = current_slot.item
	if not item.categories:
		return false

	var category_res = load("res://data/inventory/categories/" + category_name + ".tres")
	if not category_res:
		return false

	var check_is_tool = item.categories.find(category_res)
	if check_is_tool < 0:
		return false

	return true


func get_item_property(property_name: String):
	return current_slot.item.properties.get(property_name)


func play_animation(animation_name: String):
	print_debug(animation_name)
	# animated.play(animation_name)


func cancel_animation():
	animated.stop()


func _on_select_hotbar_slot(slot: Slot, index: int):
	if not slot:
		clear_current_slot()
	else:
		current_slot = slot
		current_slot_index = index


func eat_food():
	var properties = current_slot.item.properties

	if HP < MAX_HP:
		change_hp(properties.healing)
		InventoryEvents.emit_signal("decrement_slot", current_slot_index, 1)


# using when click on hotbar
func _on_use_item(slot: Slot):
	if slot and slot.item:
		var action = slot.item
		match action:
			GlobalEvents.product_actions.FOOD:
				eat_food()


# ---------------------- End Farm -------------------------------


func clear_current_slot():
	current_slot = null
	current_slot_index = -1
