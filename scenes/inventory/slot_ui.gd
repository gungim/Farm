extends Control
class_name SlotUI

@onready var icon: TextureRect = $Icon
@onready var amount_label: Label = $Amount

func update_info_slot(slot: Slot):
	if slot != null and slot.item != null:
		icon.texture = slot.item.icon
		amount_label.text = str(slot.amount)

func clear_info():
	amount_label.text = ''
