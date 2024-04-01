extends StaticBody2D
class_name HoePlace

@onready var player: Player
var id: String


func _ready():
	player = get_tree().get_first_node_in_group("Player")


func _plant():
	if not player:
		return
	if not player.current_slot_selected:
		return

	if player.check_item_by_key("seed"):
		create_plant_node(player.current_slot_selected.item)


func create_plant_node(seed_item: InventoryItem):
	var seed_type = seed_item.properties["seed_type"]

	var plant_scene: PackedScene

	if seed_type == "agriculture":
		plant_scene = load("res://scenes/farm_entity/tree/crop_tree.tscn")
	elif seed_type == "forestry":
		plant_scene = load("res://scenes/farm_entity/tree/wood_tree.tscn")

	var start_time = Time.get_unix_time_from_system()

	var node = plant_scene.instantiate()
	add_child(node)
	node.setup(start_time, seed_item.resource_name, 100)


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_plant()
