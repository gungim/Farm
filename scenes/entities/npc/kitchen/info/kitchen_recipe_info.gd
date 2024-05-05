extends RecipeInfo
class_name KitchenRecipeInfo

@onready var start_button: Button = $HBoxContainer/StartButton
@onready var item_icon: ItemIcon = $Item

@export var hotbar_db: Inventory


func _ready():
	FarmEvents.connect("start_cooking_success", _on_start_cooking_success)
	visible = false
	start_button.disabled = true


func _help_view_info(item: Recipe):
	current_recipe = item

	$Label.text = "Weo, bạn muốn nấu món " + current_recipe.display_name + " ư?"
	$TimeLabel.text = ("Thời gian: " + GlobalEvents.format_time(int(current_recipe.time)))
	check_db()


func _on_cancel_button_pressed():
	FarmEvents.emit_signal("recipe_select", null)
	current_recipe = null


func _on_start_button_pressed():
	FarmEvents.emit_signal("start_cooking", current_recipe)


# remove all item of recipe ingredients
func _on_start_cooking_success(_recipe: Recipe):
	for recipe_item in current_recipe.ingredients:
		hotbar_db.remove_item_with_amount(recipe_item.item, recipe_item.amount)


# kiểm tra các items ở trong hotbar có đủ số lượng cần thiết để làm current_recipe không
func check_db():
	start_button.disabled = !check_ingredients(hotbar_db)
