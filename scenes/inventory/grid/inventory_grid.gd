extends InventoryItemGrid
class_name InventoryGrid

func _setup():
	InventoryEvents.connect("add_item", _on_add_item)

func _on_add_item(item: InventoryItem, amount):
	print_debug(item)
	print_debug(amount)
	inventory.add_item(item, amount)
