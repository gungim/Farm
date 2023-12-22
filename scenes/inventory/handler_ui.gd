extends Control
class_name HandlerUI

@onready var texture: TextureRect = $TextureRect


func _ready():
	texture.visible = false
	InventoryEvents.connect("on_item_equipped", _on_item_equipped)
	InventoryEvents.connect("on_item_unequipped", _on_item_unequipped)

func _on_item_equipped(slot: Slot, _index):
	texture.texture = slot.item.icon
	texture.visible = true
	texture.position = get_global_mouse_position()

func _on_item_unequipped():
	texture.visible = false
	texture.texture = null
	texture.position =Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		if texture.visible:
			texture.position = get_global_mouse_position()
