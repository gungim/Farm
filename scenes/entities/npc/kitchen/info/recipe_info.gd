extends RecipeInfo
class_name KitchenRecipeInfo

@onready var start_button: Button = $HBoxContainer/StartButton
@onready var item_icon: ItemIcon = $Item

@export var hotbar_db: Inventory

var current_recipe: Recipe
var recipe_item_added: bool = false


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
	# @type:
	# valid: bool
	# array: Array[InventoryItem]
	var obj_of_amount = {}

	if not hotbar_db or not current_recipe:
		return

	# Check quantity of ingredients in db hotbar
	for recipe in current_recipe.ingredients:
		# get list item in hotbar
		var filter_slot: Array[Slot] = []
		for slot in hotbar_db.slots:
			if slot.item:
				if recipe.item == slot.item:
					filter_slot.push_back(slot)

		var obj = {"array": [], "value": false}
		obj["array"] = filter_slot

		var total_amount = filter_slot.reduce(func(sum, i): return sum + i.amount, 0)

		if total_amount >= recipe.amount:
			obj["valid"] = true
		else:
			obj["valid"] = false

		obj_of_amount[recipe.resource_name] = obj

	var checkall_valid: bool = true
	for key in obj_of_amount.keys():
		checkall_valid = checkall_valid && obj_of_amount[key].valid

	start_button.disabled = !checkall_valid
