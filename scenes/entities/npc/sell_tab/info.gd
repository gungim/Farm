extends VBoxContainer

@onready var input: SpinBox = $HSplitContainer/SpinBox
@export var inventory: Inventory

@onready var tool_res = load("res://data/inventory/categories/tool.tres")

var current_index: int
var current_slot: Slot


func _ready():
	input.min_value = 1
	input.value = 1

	hidden_button()


func view_info(index: int):
	var slot = inventory.get_slot(index)
	current_slot = slot
	current_index = index
	input.max_value = slot.amount

	var check_is_tool = slot.item.categories.find(tool_res)

	if check_is_tool >= 0:
		disable_button()
	else:
		enable_button()

	show_button()


func _on_button_sell_all_pressed():
	var amount = -int(input.max_value)
	inventory.update_amount_slot(current_index, amount)
	add_gold(amount)


func _on_button_sell_pressed():
	var amount = -int(input.value)
	inventory.update_amount_slot(current_index, amount)
	add_gold(amount)


func reset():
	current_index = -1
	hidden_button()


func add_gold(amount: int):
	var sell_price = current_slot.item.properties.get("sell")
	if not sell_price:
		sell_price = 1
	var gold_selled = amount * sell_price

	PlayerEvents.emit_signal("on_update_gold", gold_selled)
	reset()


func hidden_button():
	$HSplitContainer.visible = false
	$ButtonSellAll.visible = false


func show_button():
	$HSplitContainer.visible = true
	$ButtonSellAll.visible = true


func disable_button():
	$HSplitContainer/ButtonSell.disabled = true
	$ButtonSellAll.disabled = true


func enable_button():
	$HSplitContainer/ButtonSell.disabled = false
	$ButtonSellAll.disabled = false
