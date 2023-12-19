extends Resource
class_name Inventory

# this is database

signal updated_slot(index: int)
signal slot_added(slot_index : int)

@export var slots: Array[Slot] = []
@export var amount_slot: int = 40

func setup():
	for i in amount_slot:
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
		var item_in_slot = get_item_in_slot(i)
		
		if not item_in_slot:
			add_item_at(item, amount, i)
			break
		elif item_in_slot:
			if item_in_slot.name == item.name and slots[i].amount + amount <= item.max_stack:
				slots[i].amount += amount
				updated_slot.emit(i)
				break
			else:
				continue

func add_item_at(item: InventoryItem, amount: int, slot_index: int):
	if slot_index >= slots.size() and slot_index < 0:
		return
	slots[slot_index].item = item
	slots[slot_index].amount = amount
	updated_slot.emit(slot_index)

func get_item_in_slot(slot_index:int)->InventoryItem:
	if slot_index >= slots.size() and slot_index < 0:
		return
	return slots[slot_index].item
