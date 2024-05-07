extends GridContainer

@export var database: CookingDB

@onready var scene = load("res://scenes/entities/npc/kitchen/cooking/cooking_slot.tscn")

var slots: Array[CookingSlotUI] = []


func _ready():
	database.connect("updated_slot", _on_updated_slot)
	setup()


func setup():
	for child in get_children():
		child.queue_free()
	slots.clear()

	for item in database.list:
		create_slot_obj(null)


func _on_done_pressed():
	print_debug("Done")


func _on_cancel_pressed():
	print_debug("Cancel")


func _on_updated_slot(slot_index: int):
	var item = database.list[slot_index]
	if slot_index <= slots.size():
		create_slot_obj(item)
	slots[slot_index].update_info_slot(item)


func create_slot_obj(slot_item: Cooking):
	var obj: CookingSlotUI = scene.instantiate()
	obj.cooking = slot_item
	obj.done_pressed.connect(_on_done_pressed)
	obj.cancel_pressed.connect(_on_cancel_pressed)
	add_child(obj)
	slots.append(obj)
