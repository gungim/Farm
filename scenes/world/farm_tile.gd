extends Node2D
class_name Farm

# farming layer
var farming_layer: int = 0
# Layer cho các công trình
var construction_layer: int = 1
# Tile id
var land_tile_id: int = 0
# Biến lưu trữ pos của tile trong farm_tile
var farm_dic: Dictionary

enum lake_layer { LAKE = 1, SIDE = 0 }

enum terrains { FENCE = 0 }

@onready var hoe_place_scene = preload("res://scenes/farm_entity/tree/hoe_place.tscn")

@onready var farm_map: TileMap = $FarmMap
@onready var lake_map: TileMap = $LakeMap
@onready var entity: Node = $Entity

const lake_file_path = "res://data/lake.save"
const farm_file_path = "res://data/farm.csv"


func _ready():
	farm_dic = FarmEvents.farm_dic
	FarmEvents.connect("on_hoe", _on_hoe)
	FarmEvents.connect("on_build_fence", _on_build_fence)
	FarmEvents.connect("on_build_gate", _on_build_gate)
	# setup()

	# var file = preload(farm_file_path).records


func setup():
	setup_lake()


# ------------------------ Func for farm ---------------------------------
func _on_hoe(pos: Vector2):
	var tile_pos: Vector2i = farm_map.local_to_map(pos)
	var key = "{0},{1}".format([tile_pos.x, tile_pos.y])
	var tile = farm_dic.get(key)

	if not tile:
		farm_dic[key] = {"use": "hoe", "water_status": "Short"}
		spawn_hoe_node(tile_pos)


# -------------------- Func for build construction -----------------------
func _on_build_fence():
	var tile_pos: Vector2i = farm_map.local_to_map(farm_map.get_global_mouse_position())
	var key = "{0},{1}".format([tile_pos.x, tile_pos.y])
	var tile = farm_dic.get(key)

	if not tile:
		tile = {}
		tile["use"] = "build"
		farm_dic[key] = tile

		BetterTerrain.set_cell(farm_map, construction_layer, tile_pos, terrains.FENCE)
		BetterTerrain.update_terrain_cell(farm_map, construction_layer, tile_pos, true)


func _on_build_gate():
	print_debug("Build")
	var tile_pos: Vector2i = farm_map.local_to_map(farm_map.get_global_mouse_position())
	var gate_scene = load("res://scenes/entities/gate/gate.tscn")
	var obj_pos = Vector2i(farm_map.map_to_local(tile_pos)) - Vector2i(24, 38)
	var obj = gate_scene.instantiate()
	entity.add_child(obj)
	obj.position = obj_pos


# ------------------------ Func help for farm ---------------------------------
func set_tile_hoeed(tile: Vector2i):
	farm_map.set_cell(farming_layer, tile, land_tile_id, Vector2i(1, 0), 0)


func spawn_hoe_node(pos: Vector2i):
	var obj_scene: HoePlace = hoe_place_scene.instantiate()
	entity.add_child(obj_scene)
	obj_scene.position = farm_map.map_to_local(pos)


# key have the form "{10},{20}"
func key_to_vecter(key: String) -> Vector2i:
	var arr = key.split(",")
	return Vector2i(int(arr[0]), int(arr[1]))


# Dùng để lấy tên của tile hiện tại
func get_sprite_frames(sprite_name: String) -> SpriteFrames:
	return load("res://scenes/resources/tree_animation/" + sprite_name + ".tres")


# Tính toán ngẫu nhiên sản lượng khi thu hoạch cây,
# Sản lượng đượng tính ngẫu nhiên xung quanh default_output
func random_output(item: int, tile: Dictionary) -> int:
	var water_status = tile.get("water_status")
	var output = 0

	match water_status:
		"Mid":
			output = item * float(2) / 3
		"Short":
			output = float(item) / 3
		_:
			output = item

	var ran_output = randi_range(output - 1, output + 2)

	return ran_output


func load_farm():
	# var data  = preload(farm_file_path)
	# print_debug(data.records)
	pass


# ------------------------ Func help lake ---------------------------------
func setup_lake():
	var lake_arr = load_lake()
	BetterTerrain.set_cells(lake_map, lake_layer.LAKE, lake_arr, lake_layer.LAKE)
	BetterTerrain.update_terrain_cells(lake_map, lake_layer.LAKE, lake_arr)

	setup_side_lake(lake_arr)


# ------------------------ Func help for lake ---------------------------------


func setup_side_lake(lake_arr: Array[Vector2i]):
	var lake_side_arr: Array[Vector2i] = []
	for pos in lake_arr:
		lake_side_arr.push_back(pos)

		var top_pos = pos + Vector2i(0, -1)
		var left_pos = pos + Vector2i(-1, 0)
		var righ_pos = pos + Vector2i(1, 0)
		var bottom_pos = pos + Vector2i(0, 1)
		var top_left_pos = pos + Vector2i(-1, 1)
		var top_right_pos = pos + Vector2i(1, 1)
		var bottom_left_pos = pos + Vector2i(-1, -1)
		var bottom_right_pos = pos + Vector2i(1, -1)

		if not lake_arr.has(top_pos):
			lake_side_arr.push_back(top_pos)
		if not lake_arr.has(left_pos):
			lake_side_arr.push_back(left_pos)
		if not lake_arr.has(righ_pos):
			lake_side_arr.push_back(righ_pos)
		if not lake_arr.has(bottom_pos):
			lake_side_arr.push_back(bottom_pos)

		if not lake_arr.has(top_left_pos):
			lake_side_arr.push_back(top_left_pos)
		if not lake_arr.has(top_right_pos):
			lake_side_arr.push_back(top_right_pos)
		if not lake_arr.has(bottom_left_pos):
			lake_side_arr.push_back(bottom_left_pos)
		if not lake_arr.has(bottom_right_pos):
			lake_side_arr.push_back(bottom_right_pos)

	BetterTerrain.set_cells(lake_map, lake_layer.SIDE, lake_side_arr, lake_layer.SIDE)
	BetterTerrain.update_terrain_cells(lake_map, lake_layer.SIDE, lake_side_arr)


# ------------------------ Func help for file ---------------------------------
func load_lake() -> Array[Vector2i]:
	var file = FileAccess.open(lake_file_path, FileAccess.READ)
	var data = file.get_csv_line()
	var arr: Array[Vector2i] = []
	for item in data:
		var split_text = item.split(",")
		var vec = Vector2i(int(split_text[0]), int(split_text[1]))
		arr.push_back(vec)
	return arr
