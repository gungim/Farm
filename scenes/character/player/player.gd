extends Character
class_name Player

signal updated_hp

var target: Vector2 = Vector2.ZERO
# using to check player can farm

enum ACTIONS {HOE, PLANT, WATERING, CHOP, FOOD, HARVEST}
var farm_state = null
var current_slot_selected: Slot

@onready var weapon_manager: WeaponManager = $WeaponManager
@onready var equipment: Equipment = $Equipment


func _ready():
	change_hp(0)
	PlayerEvents.connect("on_cancel_all_action", _on_cancel_all_action)
	PlayerEvents.connect("on_use_item", _on_use_item)
	PlayerEvents.connect("on_hold_item", _on_hold_item)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			target = get_global_mouse_position()
			if PlayerEvents.allow_orther_action and position.distance_to(target) > 32:
				move_to_target()
			else:
				match farm_state:
					ACTIONS.PLANT:
						FarmEvents.emit_signal("on_plant", current_slot_selected)
						plant_tree(current_slot_selected)
					ACTIONS.HOE:
						FarmEvents.emit_signal("on_hoe")
					ACTIONS.WATERING:
						FarmEvents.emit_signal("on_watering")
					ACTIONS.HARVEST:
						FarmEvents.emit_signal("on_harvest")
						harvest()
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

func _on_cancel_all_action():
	mov_direction  = Vector2.ZERO
	fsm.set_state(fsm.states.idle)

func change_hp(value: int):
	HP += value
	if HP >= MAX_HP: HP = MAX_HP
	updated_hp.emit(HP)

func hold_item(slot: Slot):
	equipment.update_item(slot)

func decrement_slot(slot: Slot):
	slot.amount -= 1
	if slot.amount <= 0:
		current_slot_selected = null
		equipment.update_item(current_slot_selected)
	InventoryEvents.emit_signal("on_update_slot", slot)

func eat_food(slot: Slot):
	var properties = slot.item.properties
	if HP < MAX_HP:
		change_hp(properties.healing)
		decrement_slot(slot)
		
func plant_tree(slot: Slot):
	decrement_slot(slot)

func harvest():
	pass

# using when click on hotbar
func _on_use_item(slot: Slot):
	if slot and slot.item:
		var action = slot.item.action
		var actions = InventoryItem.ACTIONS
		match action:
			actions.FOOD:
				eat_food(slot)

func _on_hold_item(slot: Slot):
	current_slot_selected = slot
	if slot and slot.item:
		var action = slot.item.action
		var actions= InventoryItem.ACTIONS
		match action:
			actions.CHOP:
				pass
			actions.HOE:
				farm_state = ACTIONS.HOE
			actions.PLANT:
				farm_state = ACTIONS.PLANT
			actions.HARVEST:
				farm_state = ACTIONS.HARVEST
		hold_item(slot)
	else:
		equipment.update_item(null)
