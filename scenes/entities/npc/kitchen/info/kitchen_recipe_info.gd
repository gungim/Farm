extends RecipeInfo
class_name KitchenRecipeInfo

@onready var item_icon: ItemIcon = $Item

@export var tab_container: TabContainer


func _help_view_info():
	$Label.text = "Weo, bạn muốn nấu món " + current_recipe.display_name + " ư?"
	$TimeLabel.text = "Thời gian: " + GlobalEvents.format_time(current_recipe.time)


func _on_cancel_button_pressed():
	pass


func _on_start_button_pressed():
	if not (valid_process_thread && valid_all_db_can_remove):
		return

	var process = create_process()
	process_db.add(process)
	tab_container.current_tab = 1


# kiểm tra các items ở trong hotbar có đủ số lượng cần thiết để làm current_recipe không
func check_db():
	start_button.disabled = !check_ingredients(hotbar_db)
