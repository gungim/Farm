extends VBoxContainer

@onready var input: SpinBox = $HSplitContainer/SpinBox
@export var inventory: Inventory

var current_index: int


func _ready():
	input.min_value = 1
	input.value = 1
	$HSplitContainer.visible = false
	$ButtonSellAll.visible = false


func view_info(index: int):
	var slot = inventory.get_slot(index)
	current_index = index
	input.max_value = slot.amount

	$HSplitContainer.visible = true
	$ButtonSellAll.visible = true


func _on_button_sell_all_pressed():
	inventory.update_amount_slot(current_index, -int(input.max_value))
	reset()


func _on_button_sell_pressed():
	inventory.update_amount_slot(current_index, -int(input.value))
	reset()


func reset():
	current_index = -1
	$HSplitContainer.visible = false
	$ButtonSellAll.visible = false
