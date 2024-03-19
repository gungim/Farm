extends Node
class_name InventorySys

@export var items: Array[InventoryItem] = []
@export var inventory: Inventory


func _ready():
	add_items()


func add_items():
	if not inventory:
		return
	for item in items:
		inventory.add_item(item, 1)
