extends InventoryCore
class_name Inventory

# Using 10 last element for hotbar


func get_slot(index: int = 0) -> Slot:
	if index >= slots.size() and index < 0:
		return null
	return slots[index]


func update_slot(slot_index: int):
	updated_slot.emit(slot_index)


func get_slot_amount(index: int) -> int:
	if index >= slots.size():
		return 0
	return slots[index].amount


func add_item(item: InventoryItem, item_amount: int = 1) -> int:
	var amount_in_interact = item_amount

	for i in slots.size():
		amount_in_interact = add_item_at(item, amount_in_interact, i)
		if amount_in_interact > 0:
			continue
		else:
			break

	return amount_in_interact


func add_item_at(item: InventoryItem, item_amount: int, slot_index: int) -> int:
	if slot_index >= slots.size() and slot_index < 0:
		return item_amount

	if slots[slot_index].item and slots[slot_index].item != item:
		return item_amount

	var total_amount = slots[slot_index].amount + item_amount
	var inserted_amount = total_amount if total_amount <= item.max_stack else item.max_stack
	var remaining_amount = 0 if total_amount <= item.max_stack else total_amount - item.max_stack

	slots[slot_index].item = item
	slots[slot_index].amount = inserted_amount
	updated_slot.emit(slot_index)

	return remaining_amount


func get_item_in_slot(slot_index: int) -> InventoryItem:
	if slot_index >= slots.size() and slot_index < 0:
		return
	return slots[slot_index].item
