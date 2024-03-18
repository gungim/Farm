extends Node2D
class_name HandlerUI

@onready var sprite: Sprite2D= $Sprite2D


func _ready():
	sprite.visible = false
	InventoryEvents.connect("on_item_picked", _on_item_picked)
	InventoryEvents.connect("on_item_unpicked", _on_item_unpicked)


func _on_item_picked(slot: Slot, _index):
	sprite.texture = slot.item.icon
	sprite.visible = true
	position = get_global_mouse_position()


func _on_item_unpicked():
	sprite.visible = false
	sprite.texture = null
	position = Vector2.ZERO


func _physics_process(_delta):
	position = get_global_mouse_position()
