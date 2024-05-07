extends Resource
class_name CookingDB

@export var list: Array[Cooking]
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


func add(item: Cooking):
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
