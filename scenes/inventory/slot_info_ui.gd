extends PanelContainer
class_name SlotInfoUI

@onready var container: VBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer
@onready var item_scene = preload("res://scenes/inventory/item_info/info_item_ui.tscn")
@onready var icon_scene = preload("res://scenes/inventory/item_info/icon.tscn")


func _ready():
	clear()


func clear():
	for child in container.get_children():
		child.queue_free()


func spawn_key(key: String, value: String):
	var obj = item_scene.instantiate()
	obj.set_value(key, value)
	container.add_child(obj)


func spawn_icon(icon: Texture, property_name: String):
	var obj = icon_scene.instantiate()
	obj.set_value(icon, property_name)
	container.add_child(obj)
