extends GridContainer
class_name InventoryItemGrid

@export var inventory: Inventory = null
@export var type: String
@export var slot_scene: PackedScene
@export var show_item_name: bool = false
@export var drag_item: bool = true

var slots: Array[SlotUI] = []


func _setup():
	pass


func _ready():
	if not slot_scene:
		slot_scene = load("res://scenes/inventory/slot_ui.tscn")
	_setup_inventory()
	_setup()


func _setup_inventory():
	if not inventory:
		return

	inventory.connect("updated_slot", _on_updated_slot)
	inventory.setup()
	setup_slots()


func setup_slots():
	_reset()

	for i in inventory.amount:
		var slot_obj: SlotUI = slot_scene.instantiate()

		slot_obj.inventory = inventory
		slot_obj.index = i

		slot_obj.pressed.connect(_on_item_pressed.bind(i))

		slots.append(slot_obj)
		add_child(slots[i])

		var slot: Slot = inventory.get_slot(i)
		slot_obj.update_info_slot(slot)
		slot_obj.show_item_name = show_item_name
		slot_obj.drag_item = drag_item


func _on_updated_slot(slot_index: int):
	slots[slot_index].update_info_slot(inventory.get_slot(slot_index))


func _reset():
	for child in get_children():
		child.queue_free()
	slots.clear()


func _on_item_pressed(_index: int):
	pass
