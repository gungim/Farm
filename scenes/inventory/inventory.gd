extends Resource
class_name Inventory


signal updated_slot(index: int)
signal slot_added(slot_index : int)

@export var slots: Array[Slot] = []
@export var amount_slot: int = 40

# Using 10 last element for hotbar
@export var amount_hotbar: int = 10

func setup():
	for i in amount_slot + amount_hotbar:
		var slot_obj = Slot.new();
		slots.append(slot_obj)

func set_slot(item: InventoryItem, index: int):
	if index >= slots.size():
		return
	slots[index].item = item
	updated_slot.emit(index)

func get_slot_amount(index: int)->int:
	if index >= slots.size():
		return 0
	return slots[index].amount

func add_item(item : InventoryItem, amount : int = 1):
	for i in slots.size():
		amount = add_item_at(item, amount, i)
		if amount > 0:
			continue
		else:
			break

func add_item_at(item: InventoryItem, amount: int, slot_index: int) -> int:
	if slot_index >= slots.size() and slot_index < 0:
		return amount

	if slots[slot_index].item and slots[slot_index].item != item :
		return amount

	var total_amount = slots[slot_index].amount + amount
	var insert_amount = total_amount if total_amount <= item.max_stack else item.max_stack
	var remaining_amount = 0 if total_amount <= item.max_stack else total_amount - item.max_stack

	slots[slot_index].item = item
	slots[slot_index].amount = insert_amount
	updated_slot.emit(slot_index)

	return remaining_amount

func update_slot(slot: Slot):
	var slot_index =  slots.find(slot)
	if slot_index >= slots.size() and slot_index < 0:
		return
	slots[slot_index] = slot
	if slots[slot_index].amount <= 0:
		slots[slot_index].item = null
	updated_slot.emit(slot_index)

func get_item_in_slot(slot_index:int)->InventoryItem:
	if slot_index >= slots.size() and slot_index < 0:
		return
	return slots[slot_index].item

func remove_at(slot_index: int):
	if slot_index >= slots.size() and slot_index < 0:
		return
	slots[slot_index].amount = 0
	slots[slot_index].item = null
	updated_slot.emit(slot_index)

# Using with swap item or merge item
func swap_item(first_index: int, second_index: int):
	var first_slot = slots[first_index]
	var second_slot = slots[second_index]

	# if first item and second item equa, using merge
	if first_slot.item == second_slot.item:
		var total_amount =first_slot.amount + second_slot.amount
		var max_item_stack = first_slot.item.max_stack
		first_slot.amount = max_item_stack if total_amount > max_item_stack else total_amount
		second_slot.amount = total_amount - max_item_stack  if total_amount > max_item_stack else 0
	else:
		var temp_slot  = first_slot
		first_slot = second_slot
		second_slot = temp_slot

	slots[first_index] = first_slot
	slots[second_index] = second_slot

	updated_slot.emit(first_index)
	updated_slot.emit(second_index)
