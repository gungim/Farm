
# Using to display hotbar in screen

extends Control
class_name HotbarUI

@onready var container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var slot_scene = preload("res://scenes/inventory/slot_ui.tscn")
@onready var inventory: Inventory

var slots: Array[SlotUI] = []
var current_select_slot: Slot = null

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory = owner.inventory
	InventoryEvents.connect("on_open_inventory", _on_open_inventory)

func setup_slots():
	for child in container.get_children():
		child.queue_free()
	slots.clear()
	for i in  inventory.amount_hotbar:
		var slot_obj = slot_scene.instantiate()
		slot_obj.gui_input.connect(_on_slot_gui_input.bind(inventory.amount_slot + i))
		slots.append(slot_obj)
		container.add_child(slots[i])
		slot_obj.update_info_slot(inventory.slots[inventory.amount_slot + i])

func _on_slot_gui_input(event: InputEvent, index):
	if event is InputEventMouseButton:
		if event.button_index ==  MOUSE_BUTTON_LEFT and event.pressed:
			var slot = inventory.slots[index]
			current_select_slot = slot
			if slot != current_select_slot:
				PlayerEvents.emit_signal("on_hold_item", slot)
			else:
				PlayerEvents.emit_signal("on_use_item", slot)

func _on_open_inventory(value: bool):
	if !value:
		setup_slots()
	visible = !value
