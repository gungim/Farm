extends Resource
class_name Inventory

signal updated_slot(index: int)
signal slot_added(slot_index : int)

@export var slots: Array[Slot] = []
@export var amount_slot: int = 40

func _init():
	for i in amount_slot:
		var slot_obj = Slot.new();
		slots.append(slot_obj)

func set_slot(item: InventoryItem, index: int):
	if index >= slots.size():
		return
	slots[index].item = item
	updated_slot.emit(index)

func set_slot_with_other_slot(item: InventoryItem, index: int):
	if index >= slots.size():
		return
	slots[index].item = item
	updated_slot.emit(index)

func get_slot_amount(index: int)->int:
	if index >= slots.size():
		return 0
	return slots[index].amount

func add(item : InventoryItem, amount : int):
	var index_item_in_slots = -1;
	for i in slots.size():
		if slots[i] == null:
			_add_slot(i)
			index_item_in_slots = i;
			break
		elif slots[i].item.name == item.name:
			index_item_in_slots = i;
			break;
	
	if index_item_in_slots >=0:
		slots[index_item_in_slots].item=item
		slots[index_item_in_slots].amount += amount
		updated_slot.emit(index_item_in_slots)

func _add_slot(slot_index : int, emit_signal := true):
	var slot = Slot.new()
	slot.item = null
	slot.amount = 0
	slots.insert(slot_index, slot)
	if emit_signal:
		slot_added.emit(slot_index)


func get_max_stack_for_item(item : InventoryItem) -> int:
	return item.max_stack
