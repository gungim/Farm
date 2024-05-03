extends InventoryItemGrid
class_name InventoryGrid


func _setup():
	InventoryEvents.connect("add_item", _on_add_item)


func _on_add_item(item: InventoryItem, amount):
	inventory.add_item(item, amount)
