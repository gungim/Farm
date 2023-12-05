extends Control
class_name InventoryItemDetail

signal view_item_detail(item: InventorySlotItem)

#@export var item: InventorySlotItem

@onready var container: VBoxContainer = $VBoxContainer

func show_item_info():
	pass

func _on_view_item_detail(item):
	spawn_info(item)

func spawn_info(i: InventorySlotItem):
	for child in container.get_children():
		child.queue_free()
	if i:
		var icon_container = HBoxContainer.new()
		var item_icon = TextureRect.new()
		var item_name = Label.new()
		item_icon.set_size(Vector2(40,40))
		item_icon.texture = i.item.icon

		item_name.text = i.item.name
		icon_container.add_child(item_icon)
		icon_container.add_child(item_name)
		container.add_child(icon_container)
		
		for key in i.item.properties:
			var con = HBoxContainer.new()
			var label = Label.new()
			var val = Label.new()
			label.text = key
			val.text = i.item.properties[key]
			con.add_child(label)
			con.add_child(val)
			container.add_child(con)
		for key in i.item.categories:
			var con = HBoxContainer.new()
			var label = Label.new()
			var val = Label.new()
			label.text = key
			val.text = i.item.categories[key]
			con.add_child(label)
			con.add_child(val)
			container.add_child(con)
