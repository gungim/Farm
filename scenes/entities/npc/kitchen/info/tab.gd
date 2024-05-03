extends TabContainer

func _ready():
	set_tab_title(0, "Chi tiết")
	set_tab_title(1, "Đang nấu")

	FarmEvents.connect("recipe_select", _on_recipe_select)
	FarmEvents.connect("start_cooking_success", _on_start_cooking_success)


func _on_recipe_select(_item: Recipe):
	current_tab = 0

func _on_start_cooking_success(_recipe: Recipe):
	current_tab = 1
