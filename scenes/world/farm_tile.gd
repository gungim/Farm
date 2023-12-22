extends TileMap
class_name FarmTileMap;

var farming_layer: int = 0
var land_tile_id: int =0
var dic_of_land:Dictionary = {}
var tile: Vector2i

func _ready():
	FarmEvents.connect("on_hoe", _on_hoe)

func _on_hoe():
	tile = local_to_map(get_global_mouse_position())
	var str_tile = str(tile)
	var tile_in_dic = dic_of_land.get(str_tile)
	if not tile_in_dic:
		set_cell(farming_layer, tile, land_tile_id, Vector2i(1,0),0)
		dic_of_land[str_tile] = {
			"Type":"has_hoeed"
		}
	else:
		set_cell(farming_layer, tile, land_tile_id, Vector2i(2,0),0)
		dic_of_land[str_tile] = {
			"Type":"watered"
		}

func plant_tree():
	pass
