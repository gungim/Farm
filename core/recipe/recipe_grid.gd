extends GridContainer
class_name RecipeGrid

@export var slot_scene: PackedScene = null

@export var database: RecipeDB = null


func _ready():
	if not slot_scene:
		slot_scene = load("res://core/recipe/recipe_slot_ui.tscn")
	setup()


func setup():
	database.setup()
	for child in get_children():
		child.queue_free()

	for i in database.amount:
		var item = database.slots[i]

		var obj = slot_scene.instantiate()

		obj.pressed.connect(_item_pressed.bind(item))

		add_child(obj)
		obj.update_info(item)


func _item_pressed(_item):
	pass
