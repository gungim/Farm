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

# Using for swap item from slot_index(current index) and target index
var slot_index: int = -1
var slot: Slot = null
var equipped: bool = false
var player: Player


func _ready():
	player = get_tree().get_first_node_in_group("Player")

	on_item_select.connect(_on_item_select)
	on_open_inventory.connect(_on_open_inventory)

	on_item_picked.connect(_on_item_picked)
	on_item_unpicked.connect(_on_item_unpicked)


func _on_item_picked(item: Slot, index: int):
	slot = item
	slot_index = index
	equipped = true


func _on_item_unpicked():
	slot = null
	slot_index = -1
	equipped = false


func _on_item_select(item: Slot):
	slot = item


func _on_open_inventory(value: bool):
	is_open_inventory = value
	if not is_open_inventory:
		emit_signal("on_item_unpicked")
	else:
		PlayerEvents.emit_signal("on_cancel_all_action")
	PlayerEvents.emit_signal("on_allow_other_action", !value)
