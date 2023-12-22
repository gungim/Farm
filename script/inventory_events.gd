extends Node

# Sinal called when item equipped
signal on_item_equipped(item, index)

# Sinal called when item unequipped
signal on_item_unequipped()

# Signal called when item on inventory or iventory_hobar cliked
signal on_item_select(item)

# Signal called when open/close inventory
signal on_open_inventory

# Signal called when item used(on hotbar)
signal on_use_item(item)

signal on_change_player_can_move(value)

# set for open inventory or close
var is_open_inventory: bool = false

# Using for swap item from slot_index(current index) and target index
var slot_index: int = -1
var slot: Slot  = null
var equipped: bool = false
var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	on_item_equipped.connect(_on_item_equipped)
	on_item_unequipped.connect(_on_item_unequipped)
	on_item_select.connect(_on_item_select)
	on_open_inventory.connect(_on_open_inventory)
	on_use_item.connect(_on_use_item)


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

func _on_open_inventory():
	is_open_inventory = !is_open_inventory
	player.cancel_all_action()

func _on_use_item(item: InventoryItem):
	if item:
		print_debug(item.name)
