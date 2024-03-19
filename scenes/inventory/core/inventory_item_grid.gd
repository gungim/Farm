extends GridContainer
class_name InventoryItemGrid

@export var inventory: Inventory = null

@onready var slot_scene = preload("res://scenes/inventory/slot_ui.tscn")


var slot: Slot = null

var slots: Array[SlotUI] = []


func _ready():
	setup_inventory()


func setup_inventory():
	if not inventory:
		return

	inventory.setup()
	inventory.connect("updated_slot", _on_updated_slot.bind())
	setup_slots()


func setup_slots():
	for child in get_children():
		child.queue_free()
	slots.clear()

	for i in inventory.amount:
		var slot_obj = slot_scene.instantiate()

		slot_obj.gui_input.connect(_on_slot_gui_input.bind(i))
		slot_obj.mouse_entered.connect(_on_slot_mouse_entered.bind(i))

		slots.append(slot_obj)
		add_child(slots[i])
		slot_obj.update_info_slot(null)


func _on_updated_slot(slot_index: int):
	slots[slot_index].update_info_slot(inventory.get_slot(slot_index))


func _on_slot_gui_input(_event: InputEvent, _index: int):
	pass


func _on_slot_mouse_entered(_index: int):
	pass
