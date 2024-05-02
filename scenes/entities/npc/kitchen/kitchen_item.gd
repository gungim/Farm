extends TextureButton
class_name KitchenItem

@onready var texture: TextureRect = $TextureRect

func update_info(item: Recipe):
	if not item:
		return

	texture.texture = item.icon
