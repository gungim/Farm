extends HSplitContainer

var current_cooking: Cooking

@onready var kitchen_cooking: KitchenCooking = $TabContainer/CookingTab/MarginContainer

@export var max_thread: int = 1

var thread_used: int = 0

var inventory: Inventory


func _ready():
	FarmEvents.connect("start_cooking", _on_start_cooking)
	FarmEvents.connect("start_cooking_success", _on_start_cooking_success)
	FarmEvents.connect("cooking_finished", _on_cooking_finished)


func _on_close_button_pressed():
	visible = false


func _on_start_cooking_success(recipe: Recipe):
	if recipe:
		var current_time = Time.get_unix_time_from_system()

		var cooking = Cooking.new()
		cooking.id = recipe.name
		cooking.start_time = current_time
		cooking.recipe = recipe

		current_cooking = cooking

	kitchen_cooking.update(current_cooking)


func _on_start_cooking(item: Recipe):
	if item and thread_used <= max_thread:
		thread_used += 1
		FarmEvents.emit_signal("start_cooking_success", item)


func _on_cooking_finished():
	thread_used -= 1
	var product = current_cooking.finished_product

	inventory.add_item(product, 1)
