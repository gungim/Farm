extends TileMap
class_name FarmTileMap;

enum ACTIONS {HOE, PLANT, WATERING, CHOP, FOOD, HARVEST}

# farming layer
var farming_layer: int = 0

var land_tile_id: int =0

@onready var crop_scene = preload("res://scenes/resources/crops.tscn")

# Save tile
# Planted: true if tile is planted
# WaterStatus: Full, Mid, Short
@export var dic_of_land: Dictionary = {
	"10,5": { "Planted": true, "Seed":"seed_tomato", "WaterStatus": "Full", "StartTime": 1703686697},
	"11,6": { "Planted": false },
	"9,5" :  { "Planted": false }
}

func _ready():
	FarmEvents.connect("on_hoe", _on_hoe)
	FarmEvents.connect("on_watering", _on_watering)
	FarmEvents.connect("on_plant", _on_plant)
	FarmEvents.connect("on_harvest", _on_harvest)
	setup()

func setup():
	for key in dic_of_land:
		var tile_vec: Vector2i =  key_to_vecter(key)
		var tile_in_dic = dic_of_land[key]
		if tile_in_dic:
			set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(1,0), 0)

		if tile_in_dic["Planted"]:
			# spawn crop scene and add to current tile
			var obj_scene: Crops = crop_scene.instantiate()
			add_child(obj_scene)
			obj_scene.position = map_to_local(tile_vec) - Vector2(0, 5)
			obj_scene.id = key

			var seed_resource = load("res://scenes/inventory/item/seeds/"+tile_in_dic["Seed"]+".tres")
			obj_scene.setup(tile_in_dic["StartTime"], seed_resource)

		# Update water status
		var water_status = tile_in_dic.get("WaterStatus")
		match water_status:
			"Full":
				set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(1,0), 0)

func _on_hoe():
	var tile_vec: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile_in_dic = dic_of_land.get(key)
	if not tile_in_dic:
		set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(1,0), 0)
		dic_of_land[key] = {
			"Planted":false,
			"WaterStatus":"Short"
		}

func _on_watering():
	var tile_vec: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile_in_dic = dic_of_land.get(key)
	if tile_in_dic:
		set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(2,0), 0)
		tile_in_dic["WaterStatus"] = "Full"
		dic_of_land[key] = tile_in_dic

func _on_plant(slot: Slot):
	if not slot or not slot.item:
		return
		
	var tile_vec: Vector2i  = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile_in_dic = dic_of_land.get(key)
	if tile_in_dic and not tile_in_dic["Planted"]:
		var item_in_slot = slot.item
		if slot.item.action == ACTIONS.PLANT:
			var start_time = Time.get_unix_time_from_system()
			set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(1,0), 0)
			
			# Update type to PLANTED and set seed type, start_time
			tile_in_dic["Planted"] = true
			tile_in_dic["Seed"] = item_in_slot.name
			tile_in_dic["StartTime"] = start_time
			dic_of_land[key] = tile_in_dic
			
			# Spawn crop scene at tile vec
			var obj_scene: Crops = crop_scene.instantiate()
			var seed_res =load("res://scenes/inventory/item/seeds/"+ tile_in_dic["Seed"] + ".tres")
			
			add_child(obj_scene)
			obj_scene.setup(start_time, seed_res)
			obj_scene.position = map_to_local(tile_vec) - Vector2(0, 5)
			obj_scene.id = key

func _on_harvest():
	var tile_vec: Vector2i  = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile_in_dic = dic_of_land.get(key)
	var current_time = Time.get_unix_time_from_system()

	if tile_in_dic and tile_in_dic["Planted"]:
		var start_time = tile_in_dic.get("StartTime")
		var seed_res =load("res://scenes/inventory/item/seeds/"+ tile_in_dic["Seed"] + ".tres")

		if current_time >= start_time + seed_res.time_range:
			var water_status = tile_in_dic.get("WaterStatus")
			var output_quantity = seed_res.output_quantity
			var product_name = tile_in_dic["Seed"].get_slice("_", 1)
			# Load product resource from product_name
			var product_res = load("res://scenes/inventory/item/products/"+ product_name + ".tres")
			# Caculate output quantity
			match water_status:
				"Mid":
					output_quantity = output_quantity * 2/3
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

func key_to_vecter(key: String)-> Vector2i:
	var arr = key.split(",")
	return Vector2i(int(arr[0]), int(arr[1]))
