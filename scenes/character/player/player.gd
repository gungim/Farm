extends Character
class_name Player

signal updated_hp

var target: Vector2 = Vector2.ZERO
# using to check player can farm

enum farm_states {PLANT, HOE, WATER}
var farm_state = null
var current_slot_selected: Slot

@onready var weapon_manager: WeaponManager = $WeaponManager
@onready var equipment: Equipment = $Equipment


func _ready():
	change_hp(0)
	InventoryEvents.connect("on_change_player_can_move", _on_change_player_can_move)
	PlayerEvents.connect("on_use_item", _on_use_item)
	PlayerEvents.connect("on_hold_item", _on_hold_item)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			target = get_global_mouse_position()
			if can_move and position.distance_to(target) > 32:
				move_to_target()
			else:
				match farm_state:
					farm_states.PLANT:
						FarmEvents.emit_signal("on_plant_tile", current_slot_selected)
						plant_tree(current_slot_selected)
					farm_states.HOE:
						FarmEvents.emit_signal("on_hoe_tile")
					farm_states.WATER:
						FarmEvents.emit_signal("on_watering_tile")
	if event is InputEventKey:
		if event.keycode == KEY_SPACE and event.pressed:
			PlayerEvents.emit_signal("on_use_item")

func get_input():
	mov_direction = Input.get_vector("left", "right", "up", "down")

func _process(_delta):
	if velocity <= Vector2.ZERO:
		animated.flip_h =true
		weapon_manager.rotation = 0
	else:
		animated.flip_h = false
		weapon_manager.rotation = 180

func move_to_target():
	fsm.set_state(fsm.states.move_to_tile)
	mov_direction = position.direction_to(target)

func cancel_all_action():
	mov_direction  = Vector2.ZERO
	fsm.set_state(fsm.states.idle)

func _on_change_player_can_move(value: bool):
	can_move = value

func change_hp(value: int):
	HP += value
	if HP >= MAX_HP: HP = MAX_HP
	updated_hp.emit(HP)

func hold_item(slot: Slot):
	equipment.update_item(slot)

func eat_food(slot: Slot):
	var properties = slot.item.properties
	if HP < MAX_HP:
		change_hp(properties.increment_hp)
		slot.amount -= 1
		if slot.amount <= 0:
			current_slot_selected = null
			equipment.update_item(current_slot_selected)
		InventoryEvents.emit_signal("on_update_slot", slot)

func plant_tree(slot: Slot):
	slot.amount -= 1
	if slot.amount <= 0:
		current_slot_selected = null
		equipment.update_item(current_slot_selected)
	InventoryEvents.emit_signal("on_update_slot", slot)

func _on_use_item(slot: Slot):
	if slot and slot.item:
		var properties = slot.item.properties
		match properties.type:
			'food':
				eat_food(slot)
			'weapon':
				pass

func _on_hold_item(slot: Slot):
	if slot and slot.item:
		var properties = slot.item.properties
		match properties.type:
			'weapon':
				pass
			'farm_tool':
				farm_state = farm_states.HOE
			'seed':
				hold_item(slot)
				current_slot_selected = slot
				farm_state = farm_states.PLANT
			_:
				hold_item(slot)
	else:
		equipment.update_item(null)
