extends TextureButton
class_name SlotUI

@onready var icon: TextureRect = $Icon
@onready var amount_label: Label = $Amount

func update_info_slot(slot: Slot):
	if slot != null and slot.item != null:
		icon.texture = slot.item.icon
		amount_label.text = str(slot.amount)
	else:
		icon.texture = null
		amount_label.text = ""

func clear_info():
	amount_label.text = ''


func _on_pressed():
	Events.emit_signal("on_use_item", self)
