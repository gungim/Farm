extends VBoxContainer
class_name RecipeInfo

@onready var ingredients_grid: InventoryItemGrid = $InventoryItemGrid
@onready var start_button: Button = $HBoxContainer/StartButton
@onready var cancel_button: Button = $HBoxContainer/CancelButton

@export var hotbar_db: Inventory
@export var process_db: RecipeProcessDB

var current_recipe: Recipe

var valid_process_thread: bool = false
var valid_all_db_can_remove: bool = false


func _ready():
	visible = false
	start_button.disabled = true

	start_button.pressed.connect(_on_start_button_pressed)
	cancel_button.pressed.connect(_on_cancel_button_pressed)


func _on_start_button_pressed():
	pass


func _on_cancel_button_pressed():
	pass


func view_info(item: Recipe):
	if not item:
		visible = false
		return

	visible = true
	current_recipe = item
	check_db()
	_help_view_info()

	var col = item.ingredients.size()
	if col >= 6:
		ingredients_grid.columns = 6
	else:
		ingredients_grid.columns = col

	var database = Inventory.new()
	database.amount = col
	database.setup()
	database.slots = item.ingredients

	ingredients_grid.inventory = database
	ingredients_grid.setup_slots()


func _help_view_info():
	pass


func check_ingredients(db: Inventory) -> bool:
	# @type:
	# valid: bool
	# array: Array[InventoryItem]
	var obj_of_amount = {}

	if not db or not current_recipe:
		return false

	# Check quantity of ingredients in db hotbar
	for recipe in current_recipe.ingredients:
		# get list item in hotbar
		var filter_slot: Array[Slot] = []
		for slot in db.slots:
			if slot.item:
				if recipe.item == slot.item:
					filter_slot.push_back(slot)

		var obj = {"array": [], "valid": false}
		obj["array"] = filter_slot

		var total_amount = filter_slot.reduce(func(sum, i): return sum + i.amount, 0)

		if total_amount >= recipe.amount:
			obj["valid"] = true
		else:
			obj["valid"] = false

		obj_of_amount[recipe.item.name] = obj

	var checkall_valid: bool = true
	for key in obj_of_amount.keys():
		checkall_valid = checkall_valid && obj_of_amount[key].valid

	return checkall_valid


func check_db():
	valid_all_db_can_remove = check_ingredients(hotbar_db)
	valid_process_thread = process_db.check_slot_empty()
	if valid_process_thread && valid_all_db_can_remove:
		start_button.disabled = false
	else:
		start_button.disabled = true


func remove_hotbar_item():
	for recipe_item in current_recipe.ingredients:
		hotbar_db.remove_item_with_amount(recipe_item.item, recipe_item.amount)


func create_process() -> RecipeProcess:
	var current_time = Time.get_unix_time_from_system()

	var process = RecipeProcess.new()
	process.id = current_recipe.name + "_" + str(current_time)
	process.start_time = current_time
	process.recipe = current_recipe

	return process
