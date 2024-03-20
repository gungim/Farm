extends Node

# Sinal called when item equipped
signal on_item_equipped(item, index)

# Sinal called when item unequipped
signal on_item_unequipped

signal on_item_picked(item, index)
signal on_item_unpicked

# Signal called when item on inventory or iventory_hobar cliked
signal on_item_select(item)

# Signal called when open/close inventory
signal on_open_inventory(value)

# set for open inventory or close
var is_open_inventory: bool = false

var equipped: bool = false
var player: Player


func _ready():
	player = get_tree().get_first_node_in_group("Player")

	on_item_select.connect(_on_item_select)
	on_open_inventory.connect(_on_open_inventory)

	on_item_picked.connect(_on_item_picked)
	on_item_unpicked.connect(_on_item_unpicked)


func _on_item_picked(item: Slot, index: int):
	pass


func _on_item_unpicked():
	pass


func _on_item_select(item: Slot):
	pass


func _on_open_inventory(value: bool):
	is_open_inventory = value
	if not is_open_inventory:
		emit_signal("on_item_unpicked")
	else:
		PlayerEvents.emit_signal("on_cancel_all_action")
	PlayerEvents.emit_signal("on_allow_other_action", !value)


func move_between_inventory(from: Inventory, from_index: int, to: Inventory, to_index: int):
	var slot: Slot = from.get_slot(from_index)
	var item = slot.item
	var amount = slot.amount

	var amount_no_added = to.add_item_at(item, amount, to_index)
	if amount_no_added == 0:
		from.remove_at(from_index)
	else:
		from.add_item_at(item, amount_no_added, from_index)
