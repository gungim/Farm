extends GridContainer
class_name KitchenGrid

@onready var item_scene = load("res://scenes/farm_entity/kitchen/kitchen_item.tscn")

@export var max_thread: int = 1

var max_item: int = 40

var recipe = [
	load("res://scenes/farm_entity/kitchen/db/apple_pie.tres"),
	load("res://scenes/farm_entity/kitchen/db/bacon.tres"),
]

var thread_used: int = 0

var current_recipe: KitchenRecipe


func _ready():
	FarmEvents.connect("start_cooking", _on_start_cooking)
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


func _on_start_cooking(item: KitchenRecipe):
	if item == current_recipe:
		if thread_used <= max_thread:
			thread_used += 1
