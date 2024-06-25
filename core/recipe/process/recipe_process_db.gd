extends Resource
class_name RecipeProcessDB

@export var slots: Array[RecipeProcess]
var max_amount: int = 3

signal updated_slot(index: int)
signal removed_slot(index: int)


func update_time(id: String, time: float):
	var find_index: int = -1
	for i in range(slots.size()):
		if slots[i].id == id:
			find_index = i
			break

	if find_index == -1:
		return

	slots[find_index].completed_time = time
	updated_slot.emit(find_index)


func get_product(slot_index: int) -> InventoryItem:
	if slots.size() == 0:
		return

	if slot_index < 0 or slot_index >= slots.size():
		return

	var product = slots[slot_index].recipe.finished_product
	return product


func add(item: RecipeProcess):
	if slots.size() < max_amount:
		slots.push_back(item)
		updated_slot.emit(slots.size() - 1)


func remove_at(index: int):
	slots.remove_at(index)
	removed_slot.emit(index)


func check_slot_empty() -> bool:
	if slots.size() < max_amount:
		return true
	return false
