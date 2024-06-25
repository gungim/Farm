extends Node
class_name InventorySys

@export var hotbar_db: Inventory
@export var player_db: Inventory


func _ready():
	InventoryEvents.connect("add_item", _on_add_item)
	InventoryEvents.connect("decrement_slot", _on_decrement_slot)


func _on_add_item(item: InventoryItem, amount: int):
	hotbar_db.add_item(item, amount)


func _check_max_can_add(item: InventoryItem, amount: int) -> bool:
	var slot_empty: bool = false
	for slot in hotbar_db.slots:
		if not slot.item:
			slot_empty = true
			break
		elif slot.item == item && slot.amount + amount <= slot.item.max_stack:
			slot_empty = true
			break
	return slot_empty


func _on_decrement_slot(index: int, amount: int = 1):
	hotbar_db.update_amount_slot(index, -amount)
