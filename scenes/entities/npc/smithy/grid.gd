extends RecipeGrid

@export var info_container: SmithyRecipeInfo


func _item_pressed(item: Recipe):
	if not info_container:
		return
	info_container.view_info(item)
