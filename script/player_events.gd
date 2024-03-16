extends Node

var allow_other_action = true

# Signal called when item used(on hotbar)
signal on_use_item(item)
signal on_hold_item(item)
signal on_cancel_all_action

signal on_allow_other_action(value)

signal equipped_item(item)
signal unequipped_item(item)

var items: Array[InventoryItem] = []


func _ready():
	on_allow_other_action.connect(_on_allow_other_action)
	equipped_item.connect(_on_equipped_item)
	unequipped_item.connect(_on_unequipped_item)


func _on_allow_other_action(value: bool):
	allow_other_action = value


func _on_equipped_item(_item):
	pass


func _on_unequipped_item(_item):
	pass
