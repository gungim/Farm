extends RecipeInfo
class_name SmithyRecipeInfo

@export var tab_container: TabContainer


func _help_view_info():
	pass


func _on_cancel_button_pressed():
	current_recipe = null


func _on_start_button_pressed():
	check_db()
	if not (valid_process_thread && valid_all_db_can_remove):
		return

	remove_hotbar_item()
	var process = create_process()

	process_db.add(process)
	tab_container.current_tab = 1
