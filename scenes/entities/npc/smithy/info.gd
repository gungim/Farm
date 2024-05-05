extends VBoxContainer
class_name SmithyRecipeInfo

@onready var grid: InventoryItemGrid = $InventoryItemGrid


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
