extends Node
class_name InventorySys

@export var database: InventoryDatabase

@export var hot_bar: InventoryHotBar
@export var inventory: Inventory

func _input(event):
	if event.is_action_pressed("tab"):
		inventory.emit_signal("change_open")

func _ready():
	inventory.connect("drag_item", _on_drag_item)
	inventory.connect("drop_item", _on_drop_item)
	
func _on_drag_item(item: InventorySlotItem):
	if item:
		var drag_item = DroppedItem.new()
		drag_item.item = item
		drag_item.z_index = 10
		drag_item.spawn()
		add_child(drag_item)

func _on_drop_item(item: InventorySlotItem):
	print_debug(item.item.name)
