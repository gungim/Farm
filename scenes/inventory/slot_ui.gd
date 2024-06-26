extends TextureButton
class_name SlotUI

@onready var bg: TextureRect = $Bg
@onready var icon: TextureRect = $Icon
@onready var amount_label: Label = $AmountLabel
@onready var show_item_name: bool = false

@export var drag_item: bool = true

var inventory: Inventory
var index: int
var slot: Slot


func _ready():
	pass


func update_info_slot(new_slot: Slot):
	slot = new_slot

	if slot != null and slot.item != null:
		icon.texture = slot.item.icon
		amount_label.text = str(slot.amount) if slot.amount >= 2 else ""
		var tween = create_tween()
		tween.tween_property(bg, "scale", Vector2(1.04, 1.04), 0.4)
		tween.tween_property(bg, "scale", Vector2(1, 1), 0.3)
	else:
		icon.texture = null
		amount_label.text = ""


func clear_info():
	amount_label.text = ""


func _get_drag_data(_at_position):
	if not slot or not slot.item:
		return

	var data = {"inventory": inventory, "slot_index": index}

	var drag_texture = TextureRect.new()
	drag_texture.texture = slot.item.icon
	drag_texture.set_size(Vector2(40, 40))

	var control = Control.new()
	control.add_child(drag_texture)
	drag_texture.set_position(-0.5 * drag_texture.size)

	set_drag_preview(control)

	return data


func _can_drop_data(_at_position, _data):
	# if not slot:
	# 	return false
	return drag_item


func _drop_data(_at_position, data):
	InventoryEvents.move_between_inventory(data.inventory, data.slot_index, inventory, index)
