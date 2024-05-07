extends RecipeGrid

@export var info_container: KitchenRecipeInfo
@export var tab_container: TabContainer


func _item_pressed(item: Recipe):
	if not info_container:
		return
	info_container.view_info(item)

	tab_container.current_tab = 0
