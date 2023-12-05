extends Node
class_name Inventory


signal change_open
signal drop_item(item: InventorySlotItem)
signal drag_item(item: InventorySlotItem)

@onready var container: NinePatchRect = $MarginContainer/NinePatchRect
@onready var slots_container: GridContainer = $MarginContainer/NinePatchRect/GridContainer
@onready var player: Player
@onready var selected_item: InventorySlotItem
@onready var item_detail_container: InventoryItemDetail = $MarginContainer/NinePatchRect/ItemDetail

@export var is_open: bool = false
@export var items: Array[Item] = []

var slot_item_scene = preload("res://scenes/inventory/inventory_slot_item.tscn")
var slots: Array[InventorySlotItem] = []
var amount: int = 40

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	slots_container.columns = 9
	self.visible = is_open
	_update_slots()
	test_add_item()
	

func _update_slots():
	for child in slots_container.get_children():
		child.queue_free()
	slots.clear()
	
	for i in amount:
		var slot_obj = slot_item_scene.instantiate()
		slot_obj.emit_signal("update_item")
		slot_obj.connect("gui_input",  _on_slot_gui_input.bind(slot_obj))
		slots.append(slot_obj)
		slots_container.add_child(slot_obj)

func add_item_at(item: InventorySlotItem, index: int = 0):
	if index >= amount and index < 0:
		return
	var find_first_slot_empty: int = -1;
	if slots[index].item:
		for i in amount:
			if slots[i].item:
				return
			else:
				find_first_slot_empty = i
				break
	else:
		find_first_slot_empty = index
	if find_first_slot_empty != -1:
		slots[find_first_slot_empty].item = item.item
		slots[find_first_slot_empty].emit_signal("update_item")

func _on_change_open():
	is_open = !is_open
	self.visible = is_open
	player.emit_signal("can_move", !is_open)

func _on_slot_gui_input(event: InputEvent, slot_obj):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and  event.pressed:
			item_detail_container.emit_signal("view_item_detail", slot_obj)
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				emit_signal("drag_item", slot_obj)
			elif event.is_released():
				emit_signal("drop_item", slot_obj)

# Test
func test_add_item():
	var slot_obj = slot_item_scene.instantiate()
	slot_obj.item = items[0]
	add_item_at(slot_obj, 2)
