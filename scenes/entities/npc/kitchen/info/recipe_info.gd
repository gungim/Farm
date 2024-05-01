extends MarginContainer
class_name KitchenItemInfo

@onready var raw_material_grid: InventoryItemGrid = $VBoxContainer/RecipeInfoGrid

@onready var start_button: Button = $VBoxContainer/HBoxContainer/StartButton
@onready var item_icon: ItemIcon = $VBoxContainer/Item

@export var hotbar_db: Inventory

var current_recipe: KitchenRecipe
var recipe_item_added: bool = false


func _ready():
	FarmEvents.connect("recipe_select_item", _recipe_select_item)
	FarmEvents.connect("start_cooking_success", _on_start_cooking_success)
	visible = false
	start_button.disabled = true


func _recipe_select_item(item: KitchenRecipe):
	raw_material_grid.inventory.clear()
	raw_material_grid.reset()

	if item:
		visible = true

		current_recipe = item

		$VBoxContainer/Label.text = "Weo, bạn muốn nấu món " + item.display_name + " ư?"
		$VBoxContainer/TimeLabel.text = "Thời gian: " + GlobalEvents.format_time(item.cooking_time)
		item_icon.set_icon(item.icon)

		raw_material_grid.inventory.amount = item.ingredients.size()
		raw_material_grid.setup_inventory()

		for raw_material_item in item.ingredients:
			raw_material_grid.inventory.add_item(raw_material_item, 1)

		check_db()
	else:
		visible = false
		raw_material_grid.reset()


func _on_cancel_button_pressed():
	FarmEvents.emit_signal("recipe_select_item", null)
	current_recipe = null


func _on_start_button_pressed():
	FarmEvents.emit_signal("start_cooking", current_recipe)


# remove all item of recipe ingredients
func _on_start_cooking_success(recipe: KitchenRecipe):
	for item in recipe.ingredients:
		for db_index in hotbar_db.slots.size():
			if hotbar_db.slots[db_index].item and hotbar_db.slots[db_index].item.name == item.name:
				var remaining_amount = HotbarEvents.emit_signal("update_amount_slot", db_index, -1)
				if remaining_amount == 0:
					break


# kiểm tra các items ở trong hotbar có đủ số lượng cần thiết để làm current_recipe không
func check_db():
	if not hotbar_db or not current_recipe:
		return

	var quantity_available: Array[int] = []
	var arr_valid: Array[bool] = []

	# Check quantity of ingredients in db hotbar
	for item in current_recipe.ingredients:
		var filter_slot = hotbar_db.slots.filter(
			func(i): return i.item and item.name == i.item.name
		)
		if filter_slot.size() > 0:
			var total_amount = filter_slot.reduce(func(sum, i): return sum + i.amount, 0)
			quantity_available.push_back(total_amount)

			if total_amount >= 1:
				arr_valid.push_back(true)
			else:
				arr_valid.push_back(false)
		else:
			quantity_available.push_back(0)
			arr_valid.push_back(false)

	var find_all_invalid = arr_valid.filter(func(i): return i == false)

	if find_all_invalid.size() > 0:
		start_button.disabled = true
	else:
		start_button.disabled = false
