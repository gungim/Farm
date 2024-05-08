extends GridContainer
class_name RecipeProcessGrid

@export var database: RecipeProcessDB
@export var hotbar_db: Inventory

@onready var scene = load("res://core/recipe/process/recipe_process_slot.tscn")

var slots: Array[RecipeProcessSlot] = []


func _ready():
	database.connect("updated_slot", _on_updated_slot)
	setup()


func setup():
	for child in get_children():
		child.queue_free()
	slots.clear()

	for index in database.list.size():
		create_slot_obj(index)


func _on_done_pressed(slot_index: int):
	var product = database.get_product(slot_index)
	if product:
		hotbar_db.add_item(product)
	_remove_process(slot_index)


func _on_cancel_pressed():
	print_debug("Cancel")


func _on_updated_slot(slot_index: int):
	if slot_index <= slots.size():
		create_slot_obj(slot_index)
	var item = database.list[slot_index]
	slots[slot_index].update_info_slot(item)


func create_slot_obj(slot_index: int):
	var obj: RecipeProcessSlot = scene.instantiate()
	obj.cooking = database.list[slot_index]
	obj.done_pressed.connect(_on_done_pressed.bind(slot_index))
	obj.cancel_pressed.connect(_on_cancel_pressed)

	add_child(obj)
	slots.append(obj)


func add_process(new_proccess: RecipeProcess):
	database.add(new_proccess)


func _remove_process(index: int):
	database.remove_at(index)
	setup()
