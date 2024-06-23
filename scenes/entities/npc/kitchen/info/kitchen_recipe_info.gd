extends RecipeInfo
class_name KitchenRecipeInfo

@onready var item_icon: ItemIcon = $Item

@export var hotbar_db: Inventory
@export var process_grid: RecipeProcessGrid
@export var tab_container: TabContainer

func _help_view_info(_item: Recipe):
	$Label.text = "Weo, bạn muốn nấu món " + current_recipe.display_name + " ư?"
	$TimeLabel.text = "Thời gian: " + GlobalEvents.format_time(current_recipe.time)
	check_db()


func _on_cancel_button_pressed():
	current_recipe = null


func _on_start_button_pressed():
	for recipe_item in current_recipe.ingredients:
		hotbar_db.remove_item_with_amount(recipe_item.item, recipe_item.amount)

	var current_time = Time.get_unix_time_from_system()

	var process = RecipeProcess.new()
	process.id = current_recipe.name + "_" + str(current_time)
	process.start_time = current_time
	process.recipe = current_recipe

	process_grid.add_process(process)
	check_db()
	tab_container.current_tab = 1


# kiểm tra các items ở trong hotbar có đủ số lượng cần thiết để làm current_recipe không
func check_db():
	start_button.disabled = !check_ingredients(hotbar_db)
