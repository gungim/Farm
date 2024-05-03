extends FarmTree
class_name CropTree


func _on_mouse_exited():
	await get_tree().create_timer(3.).timeout


# TODO: chức năng thu hoạch cây nông nghiệp
func _harvest():
	if not player and not can_harvest:
		return

	var player_can_harvest = player.check_farm_state("harvest")
	if player_can_harvest == 0:
		player.play_animation("harvest")
		kill()
		_add_product_to_inventory()

func _add_product_to_inventory():
	var products: SeedProducts = seed_res.properties["products"]
	if not products:
		return

	for item in products.items:
		InventoryEvents.emit_signal("add_item", item, 1)
