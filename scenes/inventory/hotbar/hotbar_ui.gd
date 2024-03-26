# Using to display hotbar in screen

extends Control
class_name HotbarUI


func _ready():
	InventoryEvents.connect("on_open_inventory", _on_open_inventory)


func _on_open_inventory(value: bool):
	visible = !value
