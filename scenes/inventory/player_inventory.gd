extends Control
class_name PlayerInventory


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("tab") and event.pressed:
			visible = !visible
			InventoryEvents.emit_signal("on_open_inventory", visible)
