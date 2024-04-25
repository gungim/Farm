extends TabContainer
class_name CookingInfoTab


func _ready():
	set_tab_title(0, "Chi tiết")
	set_tab_title(1, "Đang nấu")

	FarmEvents.connect("recipe_select_item", _on_recipe_select_item)
	FarmEvents.connect("start_cooking_success", _on_start_cooking_success)


func _on_recipe_select_item(_item: KitchenRecipe):
	current_tab = 0

func _on_start_cooking_success(_recipe: KitchenRecipe):
	current_tab = 1
