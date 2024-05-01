extends InventoryItemGrid

@export var info: VBoxContainer


func _on_item_pressed(index: int):
	if inventory.get_slot(index):
		info.view_info(index)
