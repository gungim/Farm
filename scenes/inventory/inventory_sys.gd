extends Node
class_name InventorySys

@export var items: Array[InventoryItem] = []
@export var items_hotbar: Array[InventoryItem] = []
@export var inventory: Inventory
@export var hotbar: Inventory


func _ready():
	add_items()
	add_items_hotbar()


func add_items():
	if not inventory:
		return
	for item in items:
		inventory.add_item(item, 1)

func add_items_hotbar():
	if not hotbar:
		return
	for item in items_hotbar:
		hotbar.add_item(item, 1)
