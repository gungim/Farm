extends VBoxContainer
class_name RecipeInfo

@onready var grid: InventoryItemGrid = $InventoryItemGrid

var current_recipe: Recipe


func _ready():
	visible = false


func view_info(item: Recipe):
	_help_view_info(item)
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

	return checkall_valid
