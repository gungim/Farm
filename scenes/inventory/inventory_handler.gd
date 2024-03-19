extends Resource
class_name InventoryHandler


func add_to_inventory(inventory: Inventory, item: InventoryItem, amount: int):
	var amount_no_added = inventory.add_item(item, amount)

	pass


func move_between_inventory(from: Inventory, slot_index: int, to: Inventory):
	var slot: Slot = from.get_slot(slot_index)
	var item = slot.item
	var amount = slot.amount

	var amount_no_added = to.add_item(item, amount)
	from.remove_at(slot_index)
	from.add_item_at(item, amount_no_added, slot_index)
