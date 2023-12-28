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
	var added: bool = false
	for i in slots.size():
		var item_in_slot = get_item_in_slot(i)
		if item_in_slot:
			if item_in_slot.name == item.name and slots[i].amount + amount <= item.max_stack:
				slots[i].amount += amount
				updated_slot.emit(i)
				added = true
				break
				
	# Nếu k thêm vào được slot đã có, thì thêm vào slot trông
	if not added:
		for i in slots.size():
			var item_in_slot = get_item_in_slot(i)
			if not item_in_slot:
				add_item_at(item, amount, i)
				break

func add_item_at(item: InventoryItem, amount: int, slot_index: int):
	if slot_index >= slots.size() and slot_index < 0:
		return
	slots[slot_index].item = item
	slots[slot_index].amount = amount
	updated_slot.emit(slot_index)

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

func is_slot_empty(slot_index: int) -> int:
	if slot_index >= slots.size() and slot_index < 0: return -1
	if slots[slot_index].item: return 1
	else: return 0

func swap_item(first_index: int, second_index: int):
	var temp_item = slots[first_index].item
	var temp_amount =slots[first_index].amount
	
	slots[first_index].item = slots[second_index].item
	slots[first_index].amount = slots[second_index].amount
	
	slots[second_index].item = temp_item
	slots[second_index].amount = temp_amount
	
	updated_slot.emit(first_index)
	updated_slot.emit(second_index)
