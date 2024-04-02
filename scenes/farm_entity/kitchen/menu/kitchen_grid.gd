extends GridContainer
class_name Kitchen_Grid

@onready var item_scene = load("res://scenes/farm_entity/kitchen/kitchen_item.tscn")

@export var max_thread: int = 1

var max_item: int = 40

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

var recipe = [
	load("res://scenes/farm_entity/kitchen/db/apple_pie.tres"),
	load("res://scenes/farm_entity/kitchen/db/bacon.tres"),
]

var current_thread: int = 0


func _ready():
	setup()


func setup():
	for child in get_children():
		child.queue_free()

	for item in recipe:
		var obj: KitchenItem = item_scene.instantiate()

		obj.pressed.connect(item_pressed.bind(item))

		add_child(obj)
		obj.update_info(item)

	for index in max_item - recipe.size():
		var obj: KitchenItem = item_scene.instantiate()

		add_child(obj)
		obj.update_info(null)


func item_pressed(item):
	FarmEvents.emit_signal("kitchen_select_item", item)


func start_cooking(_recipe):
	if current_thread >= max_thread:
		current_thread += 1
