extends InventoryItemGrid
class_name HotbarGrid

func _on_slot_gui_input(event: InputEvent, index):
	pass

func _on_slot_mouse_entered(index):
	slot = inventory.get_slot(index)
	InventoryEvents.emit_signal("on_item_select", slot)
