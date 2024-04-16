extends StaticBody2D
class_name HoePlace

@onready var player: Player
var id: String

var planted: bool = false


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	input_pickable = true


func _plant():
	if not player:
		return
	if not player.current_slot_selected:
		return

	if player.check_item_by_category("seed"):
		create_plant_node(player.current_slot_selected.item)


func create_plant_node(item: InventoryItem):
	var seed_type = item.properties["seed_type"]
	if not seed_type:
		return

	var plant_scene: PackedScene

	match seed_type:
		"agriculture":
			plant_scene = load("res://scenes/farm_entity/tree/crop_tree.tscn")
		"forestry":
			plant_scene = load("res://scenes/farm_entity/tree/wood_tree.tscn")

	var start_time = Time.get_unix_time_from_system()

	var node: FarmTree = plant_scene.instantiate()

	match seed_type:
		"agriculture":
			node.time_label_visible = true

	add_child(node)
	node.setup(start_time, item, 100)
	node.connect("on_harvested", _on_harvested)

	planted = true

	input_pickable = false


func _on_harvested():
	planted = false


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_plant()
