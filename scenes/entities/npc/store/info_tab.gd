extends VBoxContainer
class_name FarmStoreInfo

@onready var label: Label = $Label
@onready var container = $Info

@onready var input: SpinBox = $Info/SpinBox

var selected_item: InventoryItem


func _ready():
	label.text = "Chọn 1 vật phẩm để xem"
	container.visible = false

	input.max_value = 999
	input.min_value = 1
	input.value = 1


func view_info(item: InventoryItem):
	selected_item = item
	label.text = "Chi tiết"
	container.visible = true
	$Info/Item.set_icon(item.icon)


func unview_info():
	label.text = "Chọn 1 vật phẩm để xem"
	container.visible = false


func _on_button_pressed():
	InventoryEvents.emit_signal("add_item", selected_item, input.value)
	input.value = 1
