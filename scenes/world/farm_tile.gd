extends TileMap
class_name FarmTileMap

enum ACTIONS { HOE, PLANT, WATERING, CHOP, FOOD, HARVEST }

# farming layer
var farming_layer: int = 0

var land_tile_id: int = 0

@onready var crop_scene = preload("res://scenes/resources/crops.tscn")

# Save farm tile
# planted: true if tile is planted
# water_status: Full, Mid, Short
# start_time: time to start planting tree
# hp: 100
@export var farm_dic: Dictionary = {
	"10,5":
	{
		"planted": true,
		"seed": "seed_tomato",
		"water_status": "Full",
		"start_time": 1703686697,
		"hp": 100,
		"product": "tomato"
	},
	"11,6": {"planted": false},
	"9,5": {"planted": false}
}


func _ready():
	FarmEvents.connect("on_hoe", _on_hoe)
	FarmEvents.connect("on_watering", _on_watering)
	FarmEvents.connect("on_plant", _on_plant)
	FarmEvents.connect("on_harvest", _on_harvest)
	FarmEvents.connect("on_chop", _on_chop)
	setup()


func setup():
	for key in farm_dic:
		var tile_vec: Vector2i = key_to_vecter(key)
		var tile_in_dic = farm_dic[key]
		if tile_in_dic:
			set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(1, 0), 0)

		if tile_in_dic["planted"]:
			# spawn crop scene and add to current tile
			var obj_scene: Crops = crop_scene.instantiate()
			add_child(obj_scene)
			obj_scene.position = map_to_local(tile_vec) - Vector2(0, 5)
			obj_scene.id = key

			var seed_resource = load(
				"res://scenes/inventory/item/seeds/" + tile_in_dic["seed"] + ".tres"
			)
			obj_scene.setup(tile_in_dic["start_time"], seed_resource)

		# Update water status
		var water_status = tile_in_dic.get("water_status")
		match water_status:
			"Full":
				set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(1, 0), 0)


func _on_hoe():
	var tile_vec: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile_in_dic = farm_dic.get(key)
	if not tile_in_dic:
		set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(1, 0), 0)
		farm_dic[key] = {"planted": false, "water_status": "Short"}


func _on_watering():
	var tile_vec: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile_in_dic = farm_dic.get(key)
	if tile_in_dic:
		set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(2, 0), 0)
		tile_in_dic["water_status"] = "Full"
		farm_dic[key] = tile_in_dic


# @params seed_slot: is seed resource
func _on_plant(seed_slot: Slot):
	if not seed_slot or not seed_slot.item:
		return

	var tile_vec: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile_in_dic = farm_dic.get(key)
	if tile_in_dic and not tile_in_dic["planted"]:
		var item_in_slot = seed_slot.item
		if seed_slot.item.action == ACTIONS.PLANT:
			var start_time = Time.get_unix_time_from_system()
			set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(1, 0), 0)

			# Update type to PLANTED and set seed type, start_time
			tile_in_dic["planted"] = true
			tile_in_dic["seed"] = item_in_slot.name
			tile_in_dic["start_time"] = start_time
			tile_in_dic["hp"] = 100
			farm_dic[key] = tile_in_dic

			# Spawn crop scene at tile vec
			var obj_scene: Crops = crop_scene.instantiate()
			var seed_res = load(
				"res://scenes/inventory/item/seeds/" + tile_in_dic["seed"] + ".tres"
			)

			add_child(obj_scene)
			obj_scene.setup(start_time, seed_res)
			obj_scene.position = map_to_local(tile_vec) - Vector2(0, 5)
			obj_scene.id = key

			# Update inventory when plant success
			seed_slot.amount -= 1
			InventoryEvents.emit_signal("on_update_slot", seed_slot)


func _on_harvest():
	var tile_vec: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile_in_dic = farm_dic.get(key)
	var current_time = Time.get_unix_time_from_system()

	if tile_in_dic and tile_in_dic["planted"]:
		var start_time = tile_in_dic.get("start_time")
		var seed_res = load("res://scenes/inventory/item/seeds/" + tile_in_dic["seed"] + ".tres")

		# check that the tree can be harvest
		if current_time >= start_time + seed_res.time_range:
			var water_status = tile_in_dic.get("water_status")
			var output_quantity = seed_res.output_quantity

			# Load product resource from product_name
			var product_res = load(
				"res://scenes/inventory/item/products/" + tile_in_dic["product"] + ".tres"
			)
			# Caculate output quantity
			match water_status:
				"Mid":
					output_quantity = output_quantity * 2 / 3
				"Short":
					output_quantity = output_quantity / 3
				_:
					output_quantity = output_quantity
			# Add product to inventory
			InventoryEvents.emit_signal("on_add_item", product_res, output_quantity)
			# remove crop scene after harvest
			for child in get_children():
				if child.id == key:
					child.queue_free()


func _on_chop(_tool: Slot):
	var tile_vec: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile_in_dic = farm_dic.get(key)

	if tile_in_dic:
		pass


# key have the form "{10},{20}"
func key_to_vecter(key: String) -> Vector2i:
	var arr = key.split(",")
	return Vector2i(int(arr[0]), int(arr[1]))
