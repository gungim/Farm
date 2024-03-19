extends InventoryItemGrid
class_name InventoryGrid


func _on_slot_gui_input(event: InputEvent, index):
	if event is InputEventMouseButton and event.is_pressed():
		slot = inventory.get_slot(index)
		InventoryEvents.emit_signal("on_item_select", slot)

		if not InventoryEvents.equipped and slot.item:
			InventoryEvents.emit_signal("on_item_picked", slot, index)
		elif InventoryEvents.equipped:
			inventory.swap_item(InventoryEvents.slot_index, index)
			InventoryEvents.emit_signal("on_item_unpicked")


func _on_slot_mouse_entered(index):
	slot = inventory.get_slot(index)
	InventoryEvents.emit_signal("on_item_select", slot)

func _can_drop_data(at_position, data):
	pass
