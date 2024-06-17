extends FarmTree
class_name CropTree


func _help_ready():
	harvest_type = HarvestType.HAND


func _on_mouse_exited():
	await get_tree().create_timer(3.).timeout


# TODO: chức năng thu hoạch cây nông nghiệp
func harvest(dmg: int):
	kill()
	_add_product_to_inventory()


func _add_product_to_inventory():
	var products: CropProducts = crop.products
	if not products:
		return

	for item in products.items:
		InventoryEvents.emit_signal("add_item", item, 1)
