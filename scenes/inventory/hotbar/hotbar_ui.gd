
# Using to display hotbar in screen

extends Control
class_name HotbarUI

@onready var container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var slot_scene = preload("res://scenes/inventory/slot_ui.tscn")
@onready var inventory: Inventory

var slots: Array[SlotUI] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory = owner.inventory

func _on_slot_gui_input(event: InputEvent, index):
	if event is InputEventMouseButton:
		if event.button_index ==  MOUSE_BUTTON_LEFT and event.pressed:
			var slot = inventory.slots[index]
			InventoryEvents.emit_signal("on_use_item", slot.item)
