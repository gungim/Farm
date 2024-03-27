extends SlotUI
class_name HotbarSlotUI

signal on_select


func _ready():
	$NinePatchRect.visible = false


func selected():
	$NinePatchRect.visible = true


func unselect():
	$NinePatchRect.visible = false


func _on_mouse_exited():
	PlayerEvents.emit_signal("on_allow_other_action", true)


func _on_mouse_entered():
	PlayerEvents.emit_signal("on_allow_other_action", false)


func _can_drop_data(_at_position, _data):
	return false


func _pressed():
	print_debug("Select item")
	PlayerEvents.emit_signal("on_select_hotbar_slot", slot)
