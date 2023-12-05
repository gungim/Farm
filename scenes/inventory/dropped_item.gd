extends Node2D
class_name DroppedItem

@export var item: InventorySlotItem
@export var is_pickable := true

func spawn():
	var texture = TextureRect.new()
	texture.set_size(Vector2(40,40))
	texture.texture = item.item.icon
	add_child(texture)

func _physics_process(delta):
	if is_pickable:
		position = get_global_mouse_position()
