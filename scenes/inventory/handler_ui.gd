extends Control
class_name HandlerUI

@onready var texture: TextureRect = $TextureRect


func _ready():
	texture.visible = false
	InventoryEvents.connect("on_item_picked", _on_item_picked)
	InventoryEvents.connect("on_item_unpicked", _on_item_unpicked)


func _on_item_picked(slot: Slot, _index):
	texture.texture = slot.item.icon
	texture.visible = true
	texture.position = get_global_mouse_position()


func _on_item_unpicked():
	texture.visible = false
	texture.texture = null
	texture.position = Vector2.ZERO


func _physics_process(_delta):
	texture.position = get_global_mouse_position()
