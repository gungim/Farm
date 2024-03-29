extends TextureButton
class_name SlotUI

@onready var icon: TextureRect = $Icon
@onready var amount_label: Label = $Amount
@onready var label: TextureRect = $Panel/TextureRect

@onready var type_label = {
	"default": preload("res://sprite/ui/generic-rpg-ui-inventario01.png"),
	"selected": preload("res://sprite/ui/generic-rpg-ui-inventario02.png"),
}

var inventory: Inventory
var index: int
var slot: Slot


func _ready():
	label.texture = type_label["default"]


func update_info_slot(new_slot: Slot):
	slot = new_slot
	if slot != null and slot.item != null:
		icon.texture = slot.item.icon
		amount_label.text = str(slot.amount) if slot.amount >= 2 else ""
	else:
		icon.texture = null
		amount_label.text = ""


func clear_info():
	amount_label.text = ""


func _get_drag_data(_at_position):
	var data = {"inventory": inventory, "slot_index": index}

	var drag_texture = TextureRect.new()
	drag_texture.texture = slot.item.icon
	drag_texture.set_size(Vector2(70, 70))

	var control = Control.new()
	control.add_child(drag_texture)
	drag_texture.set_position(-0.5 * drag_texture.size)

	set_drag_preview(control)

	return data


func _can_drop_data(_at_position, _data):
	if not slot:
		return false
	return true


func _drop_data(_at_position, data):
	InventoryEvents.move_between_inventory(data.inventory, data.slot_index, inventory, index)
