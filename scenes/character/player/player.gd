extends Character
class_name Player

# Signal được phát khi HP của player bị thay đổi
signal updated_hp

var target: Vector2 = Vector2.ZERO
# using to check player can farm

var farm_state = null
var current_slot_selected: Slot

@onready var equipment: Equipment = $Equipment
@onready var agent: NavigationAgent2D = $NavigationAgent2D


func _ready():
	change_hp(0)
	PlayerEvents.connect("on_cancel_all_action", _on_cancel_all_action)
	PlayerEvents.connect("on_use_item", _on_use_item)
	PlayerEvents.connect("on_hold_item", _on_hold_item)


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			target = get_global_mouse_position()

			if PlayerEvents.allow_other_action and position.distance_to(target) > 32:
				agent.target_position = target
				fsm.set_state(fsm.states.move_to_pos)

			elif current_slot_selected:
				var item = current_slot_selected.item

				if item is ProductionItem:
					var actions = item.action
					if actions[0] == GlobalEvents.product_actions.BUILD:
						build_barn()
				elif item is SeedItem:
					plant_tree()

				elif item is ToolItem:
					var action = item.action
					match action:
						GlobalEvents.tool_actions.HOE:
							FarmEvents.emit_signal("on_hoe")
						GlobalEvents.tool_actions.WATERING:
							FarmEvents.emit_signal("on_watering")
						GlobalEvents.tool_actions.HARVEST:
							harvest_crops()
						GlobalEvents.tool_actions.CHOP:
							chop_tree()

	if event is InputEventKey:
		if event.keycode == KEY_SPACE and event.pressed:
			PlayerEvents.emit_signal("on_use_item")


func get_input():
	mov_direction = Input.get_vector("left", "right", "up", "down")


func _process(_delta):
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
		fsm.set_state(fsm.states.idle)
		return
	mov_direction = new_dir


func _on_cancel_all_action():
	mov_direction = Vector2.ZERO
	fsm.set_state(fsm.states.idle)


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


func plant_tree():
	FarmEvents.emit_signal("on_plant", current_slot_selected)
	update_equipment_item()


func harvest_crops():
	FarmEvents.emit_signal("on_harvest")


func chop_tree():
	var item = current_slot_selected.item
	var damage = item.properties["damage"]
	var dmg: int = randi_range(damage - 2, damage + 2)
	FarmEvents.emit_signal("on_chop", dmg)


# Action xây chuồng
func build_barn():
	FarmEvents.emit_signal("on_build_barn")


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
