extends Resource
class_name Inventory

# Using 10 last element for hotbar

signal updated_slot(index: int)
signal slot_added(slot_index: int)

@export var slots: Array[Slot] = []

@export var amount: int = 40


func setup():
	var obj = Slot.new()
	if slots.size() < amount:
		for i in amount - slots.size():
			slots.push_back(obj)


func get_slot(index: int = 0) -> Slot:
	if index >= slots.size() or index < 0:
		return null

	return slots[index]


# FIX: xử lý cho trường hợp số lượng thêm vào vượt quá max-stack
func update_amount_slot(slot_index: int, amount_varies: int) -> int:
	if slot_index >= slots.size() and slot_index < 0:
		return amount_varies

	var max_stack = slots[slot_index].item.max_stack
	var total_amount = slots[slot_index].amount + amount_varies

	var inserted_amount = total_amount if total_amount <= max_stack else max_stack
	var remaining_amount = 0 if total_amount <= max_stack else total_amount - max_stack

	if inserted_amount <= 0:
		remove_at(slot_index)
	else:
		slots[slot_index].amount = inserted_amount
		updated_slot.emit(slot_index)

	return remaining_amount


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


# Clear slots
func clear():
	for i in amount:
		remove_at(i)

	amount = 0


func add_slot_at(slot: Slot, index: int):
	if index >= slots.size():
		return
	slots[index] = slot
	updated_slot.emit(index)


func remove_item_with_amount(item_removed: InventoryItem, amount_removed: int) -> int:
	var remaining_amount = 0
	var index = 0

	for slot in slots:
		if slot.item && slot.item == item_removed:
			remaining_amount = slot.amount - amount_removed

			if remaining_amount >= 0:
				slot.amount = remaining_amount
				updated_slot.emit(index)
				return 0
			else:
				slot.amount = 0
				slot.item = null
				updated_slot.emit(index)
		index += 1

	return remaining_amount


# Sử dụng để thay thể 1 slot bằng 1 slot mới
func replace_slot_at(new_slot: Slot, index: int):
	if index >= slots.size():
		return

	slots[index] = new_slot
	updated_slot.emit(index)


# xoá slot hiện tại
func remove_at(slot_index: int):
	slots[slot_index].amount = 0
	slots[slot_index].item = null
	updated_slot.emit(slot_index)
