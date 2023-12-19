extends Control

@export var inventory: Inventory
@export var item: InventoryItem
@export var item2: InventoryItem
# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.setup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.is_action_pressed("test"):
			inventory.add_item(item)
		if event.pressed and event.is_action_pressed("test2"):
			inventory.add_item(item2)
