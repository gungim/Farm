# TODO: Chức năng nấu ăn
extends MarginContainer
class_name KitchenItemInfo

@onready var raw_material_grid: InventoryItemGrid = $VBoxContainer/RecipeInfoGrid

@onready var recipe_texture: TextureRect = $VBoxContainer/TextureButton/RecipeIcon
@onready var start_button: Button = $VBoxContainer/HBoxContainer/StartButton

@export var hotbar_db: Inventory

var current_recipe: KitchenRecipe
var recipe_item_added: bool = false


func _ready():
	FarmEvents.connect("kitchen_select_item", _kitchen_select_item)
	visible = false
	start_button.disabled = true


# TODO: hiển thị số lượng
func _kitchen_select_item(item: KitchenRecipe):
	raw_material_grid.inventory.clear()
	raw_material_grid.reset()

	if item:
		visible = true

		current_recipe = item

		$VBoxContainer/Label.text = "Weo, bạn muốn nấu món " + item.display_name + " ư?"
		$VBoxContainer/TimeLabel.text = "Thời gian: " + GlobalEvents.format_time(item.cooking_time)
		recipe_texture.texture = item.icon

		raw_material_grid.inventory.amount = item.ingredients.size()
		raw_material_grid.setup_inventory()

		for raw_material_item in item.ingredients:
			raw_material_grid.inventory.add_item(raw_material_item, 1)

		check_db()
	else:
		visible = false
		raw_material_grid.reset()


func _on_cancel_button_pressed():
	FarmEvents.emit_signal("kitchen_select_item", null)
	current_recipe = null


func _on_start_button_pressed():
	FarmEvents.emit_signal("start_cooking", current_recipe)


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


func _item_drop_data(_pos, data):
	pass
