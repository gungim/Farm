extends RecipeInfo
class_name SmithyRecipeInfo

@onready var ok_button: Button = $HBoxContainer/OKButton

@export var hotbar_db: Inventory


func _ready():
	visible = false


func view_info(item: Recipe):
	if not item:
		visible = false
		return

	visible = true

	var col = item.ingredients.size()
	if col >= 6:
		grid.columns = 6
	else:
		grid.columns = col

	var database = Inventory.new()
	database.amount = col
	database.setup()
	database.slots = item.ingredients

	grid.inventory = database
	grid.setup_slots()


func _help_view_info(item: Recipe):
	current_recipe = item
	check_db()


func check_db():
	ok_button.disabled = !check_ingredients(hotbar_db)


func _on_ok_button_pressed():
	pass  # Replace with function body.


func _on_cancel_button_pressed():
	pass  # Replace with function body.
