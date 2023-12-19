extends Control
class_name InventoryUI

@onready var slot_scene = preload("res://scenes/inventory/slot_ui.tscn")

@onready var container: GridContainer = $VBoxContainer/MarginContainer/ScrollContainer/GridContainer

@export var is_open: bool = false


var inventory: Inventory
var slots: Array[SlotUI] = []

func _ready():
	inventory = owner.inventory
	setup_slots()
	setup_inventory()
	visible = is_open

func setup_inventory():
	if inventory:
		inventory.connect("updated_slot", _on_updated_slot.bind())

func setup_slots():
	for child in container.get_children():
		child.queue_free()
	slots.clear()
	
	for i in inventory.amount_slot:
		var slot_obj = slot_scene.instantiate()
		slots.append(slot_obj)
		container.add_child(slot_obj)
		slot_obj.update_info_slot(null)


func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("tab") and event.pressed:
			is_open = !is_open
			visible = is_open

func _on_updated_slot(index):
	slots[index].update_info_slot(inventory.slots[index])
