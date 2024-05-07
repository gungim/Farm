extends RecipeInfo
class_name KitchenRecipeInfo

@onready var start_button: Button = $HBoxContainer/StartButton
@onready var item_icon: ItemIcon = $Item

@export var hotbar_db: Inventory
@export var kitchen_cooking: KitchenCooking


func _ready():
	visible = false
	start_button.disabled = true


func _help_view_info(item: Recipe):
	current_recipe = item

	$Label.text = "Weo, bạn muốn nấu món " + current_recipe.display_name + " ư?"
	$TimeLabel.text = ("Thời gian: " + GlobalEvents.format_time(int(current_recipe.time)))
	check_db()


func _on_cancel_button_pressed():
	current_recipe = null


func _on_start_button_pressed():
	for recipe_item in current_recipe.ingredients:
		hotbar_db.remove_item_with_amount(recipe_item.item, recipe_item.amount)

	var current_time = Time.get_unix_time_from_system()

	var cooking = Cooking.new()
	cooking.id = current_recipe.name + "_" + str(current_time)
	cooking.start_time = current_time
	cooking.recipe = current_recipe

	kitchen_cooking.add_thread(cooking)
	check_db()


# kiểm tra các items ở trong hotbar có đủ số lượng cần thiết để làm current_recipe không
func check_db():
	start_button.disabled = !check_ingredients(hotbar_db)
