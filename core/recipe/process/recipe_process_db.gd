extends Resource
class_name RecipeProcessDB

@export var list: Array[RecipeProcess]
@export var amount: int = 3

signal updated_slot(index: int)


func update_time(id: String, time: float):
	var find_index: int = -1
	for i in range(list.size()):
		if list[i].id == id:
			find_index = i
			break

	if find_index == -1:
		return

	list[find_index].completed_time = time
	updated_slot.emit(find_index)


func get_product(slot_index: int) -> InventoryItem:
	if slot_index < 0 or slot_index >= list.size():
		return null

	var product = list[slot_index].recipe.finished_product
	return product


func add(item: RecipeProcess):
	if list.size() < amount:
		list.push_back(item)
		updated_slot.emit(list.size() - 1)


func remove(id: String):
	var find_index: int = -1
	for i in range(list.size()):
		if list[i].id == id:
			find_index = i
			break
	if find_index == -1:
		return

	list.remove_at(find_index)


func remove_at(index: int):
	list.remove_at(index)