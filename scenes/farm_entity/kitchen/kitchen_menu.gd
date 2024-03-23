extends Control
class_name KitchenMenu

@onready var grid = $GridContainer
@onready var item_scene = load("res://scenes/farm_entity/kitchen/kitchen_item.tscn")

@export var max_thread: int = 1

var cooking_recipe = [
	{
		"id": "1",
		"name": "Rice",
		"icon": load("res://scenes/inventory/item/products/rice.tres"),
		"raw_material":
		[
			load("res://scenes/inventory/item/products/rice.tres"),
			load("res://scenes/inventory/item/products/rice.tres")
		],
		"description": "Cơm"
	}
]

var current_thread: int = 0


func setup():
	for item in cooking_recipe:
		var obj = item_scene.instantiate()
		obj.set_size(Vector2(52, 52))
		obj.texture = item.icon
		obj.pressed.connect(item_pressed.bind(item))

		grid.add_child(obj)


func item_pressed(item):
	FarmEvents.emit_signal("kitchen_click_item", item)


func start_cooking(_recipe):
	if current_thread >= max_thread:
		current_thread += 1


func _on_close_button_pressed():
	visible = false
