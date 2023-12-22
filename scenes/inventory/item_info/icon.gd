extends VBoxContainer

func set_value(icon: Texture, item_name: String):
	$CenterContainer/TextureRect.texture = icon
	$CenterContainer2/Label.text = item_name
