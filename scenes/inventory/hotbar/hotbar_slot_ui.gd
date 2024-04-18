extends SlotUI
class_name HotbarSlotUI


func _can_drop_data(_at_position, _data):
	return false


func _pressed():
	if slot:
		PlayerEvents.emit_signal("on_select_hotbar_slot", slot, index)
