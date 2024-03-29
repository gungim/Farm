extends Control
class_name PlayerInventory

@export var is_open: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = InventoryEvents.is_open_inventory


func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("tab") and event.pressed:
			InventoryEvents.emit_signal("on_open_inventory", !InventoryEvents.is_open_inventory)
			visible = InventoryEvents.is_open_inventory
