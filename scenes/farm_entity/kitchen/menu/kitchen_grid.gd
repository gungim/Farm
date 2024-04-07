extends GridContainer
class_name KitchenGrid

@onready var item_scene = load("res://scenes/farm_entity/kitchen/kitchen_item.tscn")

var max_item: int = 40

var recipe = [
	load("res://scenes/farm_entity/kitchen/db/apple_pie.tres"),
	load("res://scenes/farm_entity/kitchen/db/bacon.tres"),
]

var current_recipe: KitchenRecipe


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
	FarmEvents.emit_signal("recipe_select_item", item)


