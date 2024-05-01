extends InventoryItemGrid
class_name FarmStoreGrid

@export var info_tab: FarmStoreInfo


func _on_item_pressed(index: int):
	var item: InventoryItem = inventory.get_item_in_slot(index)
	if item:
		info_tab.view_info(item)
	else:
		info_tab.unview_info()
