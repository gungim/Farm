extends GridContainer
class_name InventoryItemGrid

@export var inventory: Inventory = null
@export var type: String
@export var slot_scene: PackedScene

@onready var show_item_name: bool = false

var slots: Array[SlotUI] = []

func _setup():
	pass


func _ready():
	if not slot_scene:
		slot_scene = load("res://scenes/inventory/slot_ui.tscn")
	setup_inventory()
	_setup()


func setup_inventory():
	if not inventory:
		return

	inventory.setup()
	inventory.connect("updated_slot", _on_updated_slot)
	setup_slots()


func setup_slots():
	reset()

	for i in inventory.amount:
		var slot_obj: SlotUI = slot_scene.instantiate()

		slot_obj.inventory = inventory
		slot_obj.index = i

		slots.append(slot_obj)
		add_child(slots[i])
		slot_obj.update_info_slot(null)
		slot_obj.show_item_name = show_item_name


func _on_updated_slot(slot_index: int):
	slots[slot_index].update_info_slot(inventory.get_slot(slot_index))


func reset():
	for child in get_children():
		child.queue_free()
	slots.clear()
