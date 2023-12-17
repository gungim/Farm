extends Control

@onready var inventory = $Inventory
@export var item : InventoryItem


func _process(delta):
	if Input.is_action_just_pressed("mouse_left"):
		print("Inventory Slots:")
		for slot in inventory.slots:
			if slot.item != null:
				print(slot.item.name," x ", slot.amount)
			else:
				print("Empty")
	if Input.is_action_just_pressed("mouse_right"):
		print_debug("Added item", item)
		inventory.add(item, 1)
 
