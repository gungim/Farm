extends Control
class_name InventorySys

@export var inventory: Inventory
@export var items: Array[InventoryItem]= []
@onready var hotbar_ui: HotbarUI = $HotbarUI
# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.setup()
	hotbar_ui.setup_slots()
	add_default_item()

func add_default_item():
	for item in items:
		if item:
			inventory.add_item(item)
