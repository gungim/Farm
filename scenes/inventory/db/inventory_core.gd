extends Resource
class_name InventoryCore

signal updated_slot(index: int)
signal slot_added(slot_index: int)

var slots: Array[Slot] = []

@export var amount: int = 40


func setup():
	for i in amount:
		var slot_obj = Slot.new()
		slots.push_back(slot_obj)


func set_slot(slot: Slot, index: int):
	if index >= slots.size():
		return
	slots[index] = slot
	updated_slot.emit(index)

# Using with swap item or merge item
func swap_item(first_index: int, second_index: int):
	var first_slot = slots[first_index]
	var second_slot = slots[second_index]

	# if first item and second item equa, using merge
	if first_slot.item == second_slot.item:
		var total_amount = first_slot.amount + second_slot.amount
		var max_item_stack = first_slot.item.max_stack
		first_slot.amount = max_item_stack if total_amount > max_item_stack else total_amount
		second_slot.amount = total_amount - max_item_stack if total_amount > max_item_stack else 0
	else:
		var temp_slot = first_slot
		first_slot = second_slot
		second_slot = temp_slot

	slots[first_index] = first_slot
	slots[second_index] = second_slot

	updated_slot.emit(first_index)
	updated_slot.emit(second_index)

func remove_at(slot_index: int):
	if slot_index >= slots.size() and slot_index < 0:
		return
	slots[slot_index].amount = 0
	slots[slot_index].item = null
	updated_slot.emit(slot_index)
