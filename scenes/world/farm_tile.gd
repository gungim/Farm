extends TileMap
class_name FarmTileMap;

# farming layer
var farming_layer: int = 0

var land_tile_id: int =0

@onready var crop_scene = preload("res://scenes/resources/crops.tscn")

# Save tile
# Planted: true if tile is planted
# WaterStatus: Full, Mid, Short
@export var dic_of_land: Dictionary = {
	"10, 5": { "Planted": true, "WaterStatus": "Full" },
	"11, 6": { "Planted": true },
	"9, 5" :  { "Planted": true } 
}

func _ready():
	FarmEvents.connect("on_hoe_tile", _on_hoe_tile)
	FarmEvents.connect("on_watering_tile", _on_watering_tile)
	FarmEvents.connect("on_plant_tile", _on_plant_tile)
	setup()

func setup():
	for key in dic_of_land:
		var tile_vec: Vector2i =  key_to_vecter(key)
		if dic_of_land[key].get("Planted"):
			set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(1,0), 0)
			var obj_scene: Crops = crop_scene.instantiate()
			
			add_child(obj_scene)
			obj_scene.setup(dic_of_land[key].get("StartTime"))
			obj_scene.position = map_to_local(tile_vec) - Vector2(0, 5)
		var water_status = dic_of_land[key].get("WaterStatus")
		match water_status:
			"Full":
				set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(1,0), 0)

func _on_hoe_tile():
	var tile: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile.x, tile.y])
	var tile_in_dic = dic_of_land.get(key)
	if not tile_in_dic:
		set_cell(farming_layer, tile, land_tile_id, Vector2i(1,0), 0)
		dic_of_land[key] = {
			"Planted":false,
			"WaterStatus":"Short"
		}

func _on_watering_tile():
	var tile: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile.x, tile.y])
	var tile_in_dic = dic_of_land.get(key)
	if tile_in_dic:
		set_cell(farming_layer, tile, land_tile_id, Vector2i(2,0), 0)
		tile_in_dic["WaterStatus"] = "Full"
		dic_of_land[key] = tile_in_dic

func _on_plant_tile(slot: Slot):
	if slot and slot.item:
		var tile: Vector2i  = local_to_map(get_global_mouse_position())
		var key = "{0},{1}".format([tile.x, tile.y])
		var tile_in_dic = dic_of_land.get(key)
		
		if tile_in_dic and not tile_in_dic["Planted"]:
			var item_in_slot = slot.item
			if item_in_slot.properties.get('type') == "seed":
				var start_time = Time.get_datetime_dict_from_system()
				set_cell(farming_layer, tile, land_tile_id, Vector2i(1,0), 0)
				
				# Update type to PLANTED and set seed type, start_itime
				tile_in_dic["Planted"] = true
				tile_in_dic["Seed"] = item_in_slot.name
				tile_in_dic["StartTime"] = start_time
				dic_of_land[key] = tile_in_dic
				
				# Spawn crop scene at tile vec
				var tile_vec: Vector2i =  key_to_vecter(key)
				set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(1,0), 0)
				var obj_scene: Crops = crop_scene.instantiate()
				
				add_child(obj_scene)
				obj_scene.setup(null)
				obj_scene.position = map_to_local(tile_vec) - Vector2(0, 5)

func key_to_vecter(key: String)-> Vector2i:
	var arr = key.split(",")
	return Vector2i(int(arr[0]), int(arr[1]))
