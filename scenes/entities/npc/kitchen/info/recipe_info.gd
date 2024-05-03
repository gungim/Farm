extends MarginContainer

@onready var raw_material_grid: InventoryItemGrid = $VBoxContainer/InventoryItemGrid

@onready var start_button: Button = $VBoxContainer/HBoxContainer/StartButton
@onready var item_icon: ItemIcon = $VBoxContainer/Item

@export var hotbar_db: Inventory

var current_recipe: Recipe
var recipe_item_added: bool = false

# @type:
# valid: bool
# array: Array[InventoryItem]
var obj_of_amount = {}


func _ready():
	FarmEvents.connect("recipe_select_item", _recipe_select_item)
	FarmEvents.connect("start_cooking_success", _on_start_cooking_success)
	visible = false
	start_button.disabled = true


func _recipe_select_item(item: Recipe):
	if item:
		visible = true

		current_recipe = item

		$VBoxContainer/Label.text = "Weo, bạn muốn nấu món " + item.display_name + " ư?"
		$VBoxContainer/TimeLabel.text = "Thời gian: " + GlobalEvents.format_time(int(item.time))
		item_icon.set_icon(item.icon)

		raw_material_grid.inventory.amount = item.ingredients.size()
		raw_material_grid.inventory.slots = item.ingredients
		raw_material_grid.setup_slots()

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
# TODO: update hotbar slot when start cooking
func _on_start_cooking_success(recipe: Recipe):
	for recipe_item in recipe.ingredients:
		var amount_need_decrement = recipe_item.amount

		for db_index in hotbar_db.slots.size():
			var slot = hotbar_db.get_slot(db_index)

			if slot.item and slot.item.name == recipe_item.item.name:
				if slot.amount >= amount_need_decrement:
					hotbar_db.update_amount_slot(db_index, -amount_need_decrement)
					break
				else:
					amount_need_decrement = amount_need_decrement - slot.amount
					hotbar_db.update_amount_slot(db_index, -slot.amount)


# kiểm tra các items ở trong hotbar có đủ số lượng cần thiết để làm current_recipe không
func check_db():
	obj_of_amount = {}
	if not hotbar_db or not current_recipe:
		return

	# Check quantity of ingredients in db hotbar
	for recipe in current_recipe.ingredients:
		# get list item in hotbar
		var filter_slot: Array[Slot] = []
		for slot in hotbar_db.slots:
			if slot.item:
				if recipe.item.name == slot.item.name:
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

	print_debug(checkall_valid)
	if checkall_valid:
		start_button.disabled = true
	else:
		start_button.disabled = false
