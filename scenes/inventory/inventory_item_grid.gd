extends GridContainer
class_name InventoryItemGrid

@export var inventory: Inventory = null
@export var type: String
@onready var slot_scene = preload("res://scenes/inventory/slot_ui.tscn")

var slot: Slot = null

var slots: Array[SlotUI] = []


func _ready():
	setup_inventory()


func setup_inventory():
	if not inventory:
		return

	inventory.setup()
	inventory.connect("updated_slot", _on_updated_slot)
	setup_slots()


func setup_slots():
	for child in get_children():
		child.queue_free()
	slots.clear()

	for i in inventory.amount:
		var slot_obj = slot_scene.instantiate()

		slot_obj.inventory = inventory
		slot_obj.index = i

		slots.append(slot_obj)
		add_child(slots[i])
		slot_obj.update_info_slot(null)


func _on_updated_slot(slot_index: int):
	slots[slot_index].update_info_slot(inventory.get_slot(slot_index))
