extends Node

signal on_connect_inventory(inven)
signal on_update_slot(slot)

# Sinal called when item equipped
signal on_item_equipped(item, index)

# Sinal called when item unequipped
signal on_item_unequipped

# Signal called when item on inventory or iventory_hobar cliked
signal on_item_select(item)

signal on_add_item(item, amount)

# Signal called when open/close inventory
signal on_open_inventory(value)

# set for open inventory or close
var is_open_inventory: bool = false

# Using for swap item from slot_index(current index) and target index
var slot_index: int = -1
var slot: Slot = null
var equipped: bool = false
var player: Player
var inventory: Inventory


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	on_item_equipped.connect(_on_item_equipped)
	on_item_unequipped.connect(_on_item_unequipped)
	on_item_select.connect(_on_item_select)
	on_open_inventory.connect(_on_open_inventory)
	on_connect_inventory.connect(_on_connect_inventory)
	on_update_slot.connect(_on_update_slot)
	on_add_item.connect(_on_add_item)


func _on_item_equipped(item: Slot, index: int):
	slot = item
	slot_index = index
	equipped = true


func _on_item_unequipped():
	slot = null
	slot_index = -1
	equipped = false


func _on_item_select(item: Slot):
	slot = item


func _on_open_inventory(value: bool):
	is_open_inventory = value
	if not is_open_inventory:
		emit_signal("on_item_unequipped")
	else:
		PlayerEvents.emit_signal("on_cancel_all_action")
	PlayerEvents.emit_signal("on_allow_other_action", !value)


func _on_connect_inventory(inven):
	inventory = inven


func _on_add_item(item: InventoryItem, amount: int = 1):
	inventory.add_item(item, amount)


func _on_update_slot(item: Slot):
	inventory.update_slot(item)
