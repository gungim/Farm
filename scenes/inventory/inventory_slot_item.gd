extends Control
class_name InventorySlotItem

signal update_item
signal use_item


var textures = [
	preload("res://sprite/ui/generic-rpg-ui-inventario01.png"),
	preload("res://sprite/ui/generic-rpg-ui-inventario02.png"),
]

@export var item: Item

func _ready():
	update_label()
	set_item()

func _get_minimum_size():
	return Vector2(40, 40)
func set_item():
	if item:
		var texture: TextureRect = TextureRect.new()
		texture.texture = item.icon
		texture.size = Vector2(40, 40)
		add_child(texture)

func update_label():
	if item:
		$BG.texture = textures[1]
	else:
		$BG.texture = textures[0]


func _on_update_item():
	update_label()
	set_item()
