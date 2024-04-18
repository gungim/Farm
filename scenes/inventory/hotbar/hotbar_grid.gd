extends InventoryItemGrid
class_name HotbarGrid


func _setup():
	FarmEvents.connect("update_amount_slot", _on_update_amount_slot)


func _on_update_amount_slot(index: int, amount: int):
	inventory.update_amount_slot(index, amount)
