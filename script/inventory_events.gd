extends Node

# Signal called when open/close inventory
signal on_open_inventory(value)

signal add_item(item: InventoryItem, amount: int)

# set for open inventory or close
var is_open_inventory: bool = false

var player: Player


func _ready():
	player = get_tree().get_first_node_in_group("Player")

	on_open_inventory.connect(_on_open_inventory)


func _on_open_inventory(value: bool):
	is_open_inventory = value
	PlayerEvents.emit_signal("on_disable_player", value)


func move_between_inventory(from: Inventory, from_index: int, to: Inventory, to_index: int):
	var slot: Slot = from.get_slot(from_index)
	var item = slot.item
	var amount = slot.amount

	var amount_no_added = to.add_item_at(item, amount, to_index)
	if amount_no_added == 0:
		from.remove_at(from_index)
	else:
		from.add_item_at(item, amount_no_added, from_index)
