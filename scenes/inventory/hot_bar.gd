extends Control
class_name InventoryHotBar

@onready var slots_container: HBoxContainer = $HBoxContainer
@onready var player: Player

@export var items: Array[Item] = []

var amount: int = 10
var slot_item_scene = preload("res://scenes/inventory/inventory_slot_item.tscn")
var slots: Array[InventorySlotItem] = []

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	_update_slots()

func _update_slots():
	for child in slots_container.get_children():
		child.queue_free()
	slots.clear()
	
	for i in amount:
		var slot_obj = slot_item_scene.instantiate()
		if i <  items.size():
			slot_obj.item = items[i]
		slot_obj.emit_signal("update_item")
		slot_obj.connect("gui_input",  _on_slot_gui_input.bind(slot_obj))
		slots.append(slot_obj)
	
	for slot in slots:
		slots_container.add_child(slot)

func add_item_at(item: Item, index: int = 0):
	if item and index >=0 and index <= amount:
		var slot_obj = slot_item_scene.instantiate()
		slot_obj.item = item
		slots[index] = slot_obj 
		update_slot()

func update_slot():
	for child in slots_container.get_children():
		slots_container.remove_child(child)
	for slot in slots:
		slots_container.add_child(slot)

func remove_item(id):
	pass

func update_item():
	pass

func check_empty_slot(index: int)->bool:
	if slots.is_empty()  or slots.size() > index: return true;
	if slots[index] == null: return true;
	else: return true

func find_first_slot_empty() -> int:
	for i in amount:
		if check_empty_slot(i): return i
	return -1

func _on_slot_gui_input(event: InputEvent, slot_obj: InventorySlotItem):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and  event.pressed:
			if slot_obj.item:
				var cat = slot_obj.item.categories;
				if cat.has("type"):
					print_debug(slot_obj.item.name)
