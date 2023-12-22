extends TextureButton
class_name SlotUI

@onready var icon: TextureRect = $Icon
@onready var amount_label: Label = $Amount

func update_info_slot(slot: Slot):
	if slot != null and slot.item != null:
		icon.texture = slot.item.icon
		amount_label.text = str(slot.amount) if slot.amount >= 2 else ""
	else:
		icon.texture = null
		amount_label.text = ""

func clear_info():
	amount_label.text = ''


func _on_mouse_entered():
	InventoryEvents.emit_signal("on_change_player_can_move", false)


func _on_mouse_exited():
	InventoryEvents.emit_signal("on_change_player_can_move", true)
