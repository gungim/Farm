extends RecipeGrid

func _item_pressed(item):
	FarmEvents.emit_signal("recipe_select", item)
