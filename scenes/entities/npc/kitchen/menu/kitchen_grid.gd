extends GridContainer
class_name KitchenGrid

@onready var item_scene = load("res://scenes/entities/npc/kitchen/kitchen_item.tscn")

@export var database: RecipeDB


func _ready():
	setup()


func setup():
	database.setup()
	for child in get_children():
		child.queue_free()

	for item in database.slots:
		var obj: KitchenItem = item_scene.instantiate()

		obj.pressed.connect(item_pressed.bind(item))

		add_child(obj)
		obj.update_info(item)


func item_pressed(item):
	FarmEvents.emit_signal("recipe_select_item", item)
