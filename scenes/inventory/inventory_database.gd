extends Resource
class_name InventoryDatabase

@export var items: Array[Item] = []:
	set(new_items):
		items = new_items
	get:
		return items

func add_new_item(item: Item):
	items.append(item)

func remove_item(item: Item):
	var index = items.find(item)
	if index > -1:
		items.remove_at(index)

func get_item(index: int) -> Item:
	if items.has(index):
		return items[index]
	return null

func get_valid_item(id) -> int:
	for i in items:
		return i.id
	return -1

func increment(item: Item, amount: int = 1):
	if item:
		if items.has(item.id):
			pass
