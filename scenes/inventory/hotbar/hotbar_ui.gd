# Using to display hotbar in screen

extends Control
class_name HotbarUI

@onready var container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var slot_scene = preload("res://scenes/inventory/hotbar/hotbar_slot_ui.tscn")
@onready var inventory: Inventory

var slots: Array[HotbarSlotUI] = []
var selected_slot_index: int = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	inventory = owner.inventory
	setup_inventory()
	InventoryEvents.connect("on_open_inventory", _on_open_inventory)


func setup_inventory():
	inventory.connect("updated_slot", _on_updated_slot.bind())


func setup_slots():
	for child in container.get_children():
		child.queue_free()
	slots.clear()
	for i in inventory.amount_hotbar:
		var slot_obj = slot_scene.instantiate()
		slot_obj.pressed.connect(_on_slot_pressed.bind(inventory.amount_slot + i))
		slots.append(slot_obj)
		container.add_child(slots[i])
		slot_obj.update_info_slot(inventory.get_slot(inventory.amount_slot + i))


# chỉ chấp nhận slot_index >= inventory.amount_slot
func _on_updated_slot(slot_index):
	if slot_index >= inventory.amount_slot:
		var index = (
			slot_index if slot_index < inventory.amount_slot else slot_index - inventory.amount_slot
		)
		slots[index].update_info_slot(inventory.slots[slot_index])


func _on_slot_pressed(index):
	var slot = inventory.slots[index]
	PlayerEvents.emit_signal("on_hold_item", slot)

	selected_slot_index = (
		index if index < inventory.amount_slot else index - inventory.amount_slot
	)
	for child in slots:
		child.unselect()

		# elif event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
		# 	PlayerEvents.emit_signal("on_use_item", slot)
	slots[selected_slot_index].selected()
	# elif event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
	# 	PlayerEvents.emit_signal("on_use_item", slot)


func _on_open_inventory(value: bool):
	if !value:
		setup_slots()
	visible = !value
