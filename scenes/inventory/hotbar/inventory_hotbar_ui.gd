# Using to display hotbar in inventory
extends Control
class_name InventoryHotbarUI

@onready var container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var slot_scene = preload("res://scenes/inventory/slot_ui.tscn")
@onready var inventory: Inventory

var slots: Array[SlotUI] = []


func get_slot_index(_output: int) -> int:
	return -1


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
	for i in inventory.amount_hotbar:
		var slot_obj = slot_scene.instantiate()
		slot_obj.pressed.connect(_on_slot_pressed.bind(inventory.amount_slot + i))
		slots.append(slot_obj)
		container.add_child(slots[i])
		slot_obj.update_info_slot(null)


# chỉ chấp nhận slot_index >= inventory.amount_slot
func _on_updated_slot(slot_index):
	if slot_index >= inventory.amount_slot:
		var index = (
			slot_index if slot_index < inventory.amount_slot else slot_index - inventory.amount_slot
		)
		slots[index].update_info_slot(inventory.slots[slot_index])


func _on_slot_pressed(index):
	var slot = inventory.slots[index]
	if InventoryEvents.slot != slot and slot.item:
		InventoryEvents.emit_signal("on_item_select", slot)
	else:
		if not InventoryEvents.equipped and slot.item:
			InventoryEvents.emit_signal("on_item_picked", slot, index)
		elif InventoryEvents.equipped:
			inventory.swap_item(InventoryEvents.slot_index, index)
			InventoryEvents.emit_signal("on_item_unpicked")
