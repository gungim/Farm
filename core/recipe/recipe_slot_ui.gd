extends TextureButton
class_name RecipeSlotUI

@onready var icon_texture: TextureRect = $TextureRect

func update_info(item: Recipe):
	if item.icon:
		icon_texture.texture = item.icon

