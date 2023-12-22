extends Control
class_name InventorySys

@export var inventory: Inventory
@export var items: Array[InventoryItem]= []
# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.setup()
	add_default_item()

func add_default_item():
	for item in items:
		if item:
			inventory.add_item(item)
