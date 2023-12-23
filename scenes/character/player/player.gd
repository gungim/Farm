extends Character
class_name Player
var target: Vector2 = Vector2.ZERO
# using to check player can farm
var can_farm: bool = false

@onready var weapon_manager: WeaponManager = $WeaponManager
@onready var equipment: Equipment = $Equipment

func _ready():
	InventoryEvents.connect("on_change_player_can_move", _on_change_player_can_move)
	PlayerEvents.connect("on_use_item", _on_use_item)
	PlayerEvents.connect("on_hold_item", _on_hold_item)

func _input(event):
	if event.is_action_pressed("mouse_left"):
		target = get_global_mouse_position()
		if can_move and position.distance_to(target) > 32:
			move_to_target()
		elif can_farm and position.distance_to(target) <= 32:
			FarmEvents.emit_signal("on_hoe")
		
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

func change_is_farming(value):
	can_farm = value
	
func _on_change_player_can_move(value: bool):
	can_move = value

func hold_item(_slot: Slot):
	pass

func eat_food(slot: Slot):
	var properties = slot.item.properties
	change_hp(properties.increment_hp)
	UiEvents.emit_signal("update_hp_label", HP)
#	InventoryEvents.emit_signal()

func _on_use_item(slot: Slot):
	if slot and slot.item:
		var properties = slot.item.properties
		match properties.type:
			'tool':
				pass
			'food':
				eat_food(slot)
			'seed':
				equipment.update_item(slot)
			'weapon':
				pass
	else:
		equipment.update_item(null)

func _on_hold_item(slot: Slot):
	if slot and slot.item:
		var properties = slot.item.properties
		match properties.type:
			'tool':
				pass
			'food':
				equipment.update_item(slot)
			'seed':
				equipment.update_item(slot)
			'weapon':
				pass
	else:
		equipment.update_item(null)
