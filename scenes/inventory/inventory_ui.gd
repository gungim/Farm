extends Control
class_name InventoryUI

@onready var slot_scene = preload("res://scenes/inventory/slot_ui.tscn")

@onready var container: GridContainer = $MarginContainer/ScrollContainer/GridContainer

@onready var inventory: Inventory

var slots: Array[SlotUI] = []
var slot: Slot = null


func _ready():
	inventory = get_tree().get_first_node_in_group("InventorySys").inventory
	setup_inventory()
	setup_slots()


func setup_inventory():
	inventory.connect("updated_slot", _on_updated_slot.bind())


func setup_slots():
	for child in container.get_children():
		child.queue_free()
	slots.clear()
	for i in inventory.amount_slot:
		var slot_obj = slot_scene.instantiate()
		slot_obj.gui_input.connect(_on_slot_gui_input.bind(i))
		slots.append(slot_obj)
		container.add_child(slots[i])
		slot_obj.update_info_slot(null)


func _on_updated_slot(slot_index: int):
	if slot_index < inventory.amount_slot:
		var index = (
			slot_index
			if slot_index < inventory.amount_slot
			else slot_index - inventory.amount_slot - 1
		)
		slots[index].update_info_slot(inventory.get_slot(slot_index))


func _on_slot_gui_input(event: InputEvent, index):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			slot = inventory.get_slot(index)
			InventoryEvents.emit_signal("on_item_select", slot)

			if not InventoryEvents.equipped and slot.item:
				InventoryEvents.emit_signal("on_item_picked", slot, index)
			elif InventoryEvents.equipped:
				inventory.swap_item(InventoryEvents.slot_index, index)
				InventoryEvents.emit_signal("on_item_unpicked")

	if event is InputEventMouseMotion:
		slot = inventory.get_slot(index)
		InventoryEvents.emit_signal("on_item_select", slot)
