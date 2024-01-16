extends TextureButton
class_name SlotUI

@onready var icon: TextureRect = $Icon
@onready var amount_label: Label = $Amount
@onready var label: TextureRect = $Panel/TextureRect

@onready var type_label = {
	"default": preload("res://sprite/ui/generic-rpg-ui-inventario01.png"),
	"selected": preload("res://sprite/ui/generic-rpg-ui-inventario02.png"),
}


func _ready():
	label.texture = type_label["default"]


func update_info_slot(slot: Slot):
	if slot != null and slot.item != null:
		icon.texture = slot.item.icon
		amount_label.text = str(slot.amount) if slot.amount >= 2 else ""
	else:
		icon.texture = null
		amount_label.text = ""


func clear_info():
	amount_label.text = ""
