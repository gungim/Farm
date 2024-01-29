extends Node
class_name FarmTileMap

enum ACTIONS { HOE, PLANT, WATERING, FOOD, HARVEST }

# farming layer
var farming_layer: int = 0

var land_tile_id: int = 0

@onready var crop_scene = preload("res://scenes/farm_entity/crops/crops.tscn")
@onready var pine_tree_res = preload("res://scenes/resources/tree_animation/pine.tres")
@onready var tilemap: TileMap = $FarmTileMap
@onready var entity: Node = $Entity

# Save farm tile
# planted: true if tile is planted
# water_status: Full, Mid, Short
# start_time: time to start planting tree
# hp: 100
@export var farm_dic: Dictionary


func _ready():
	farm_dic = FarmEvents.farm_dic
	FarmEvents.connect("on_hoe", _on_hoe)
	FarmEvents.connect("on_watering", _on_watering)
	FarmEvents.connect("on_plant", _on_plant)
	FarmEvents.connect("on_harvest_crops", _on_harvest_crops)
	FarmEvents.connect("on_chop", _on_chop_tree)
	FarmEvents.connect("on_build_barn", _on_build_barn)
	setup()


func setup():
	for key in farm_dic:
		var tile_vec: Vector2i = key_to_vecter(key)
		var tile = farm_dic[key]
		if not tile:
			return

		if tile["use"] == "plant":
			spawn_crop_node(tile_vec, tile["seed"], tile["start_time"])

		# Update water status
		if tile["use"] == "plant":
			var water_status = tile.get("water_status")
			if not water_status:
				water_status = "Short"
			set_cell_watered(tile_vec, water_status)
		elif tile["use"] == "build":
			set_cell_builded(tile_vec)


func _on_hoe():
	var tile_vec: Vector2i = tilemap.local_to_map(tilemap.get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile = farm_dic.get(key)
	if not tile:
		set_cell_watered(tile_vec, "Shhort")
		farm_dic[key] = {"use": "plant", "water_status": "Short"}


func _on_watering():
	var tile_vec: Vector2i = tilemap.local_to_map(tilemap.get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile = farm_dic.get(key)

	if not tile:
		return

	if tile["use"] == "plant":
		set_cell_watered(tile_vec, "Full")
		tile["water_status"] = "Full"
		farm_dic[key] = tile


# @params seed_slot: is seed resource
func _on_plant(seed_slot: Slot):
	if not seed_slot or not seed_slot.item:
		return

	var tile_vec: Vector2i = tilemap.local_to_map(tilemap.get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile = farm_dic.get(key)

	if not tile:
		return

	if tile["use"] == "plant":
		if seed_slot.item is SeedItem and seed_slot.amount > 0:
			var start_time = Time.get_unix_time_from_system()

			# Update type to PLANTED and set seed type, start_time
			tile["use"] = "plant"
			tile["seed"] = seed_slot.item.resource_name
			tile["start_time"] = start_time
			tile["hp"] = 100
			farm_dic[key] = tile

			spawn_crop_node(tile_vec, tile["seed"], start_time)
			set_cell_watered(tile_vec, "Short")

			# Update inventory when plant success
			seed_slot.amount -= 1
			InventoryEvents.emit_signal("on_update_slot", seed_slot)


func _on_add_tree(tree: Resource):
	var tile_vec: Vector2i = tilemap.local_to_map(tilemap.get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile = farm_dic.get(key)

	if not tile:
		tile = {}
		tile["use"] = "plant"
		tile["seed"] = tree.resource_name
		tile["start_time"] = 00
		tile["hp"] = 100
		farm_dic[key] = tile

		spawn_crop_node(tile_vec, tile["seed"], 0)
		set_cell_watered(tile_vec, "Short")


func _on_harvest_crops():
	var tile_vec: Vector2i = tilemap.local_to_map(tilemap.get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile = farm_dic.get(key)

	if not tile:
		return

	if tile["use"] == "plant" and check_harvestable_tile(tile):
		var seed_res = get_resource(tile["seed"])

		# Add product to inventory
		for item in seed_res.product:
			var ran_output = random_output(item.amount, tile)
			InventoryEvents.emit_signal("on_add_item", item.res, ran_output)
		# remove crop scene after harvest
		for child in get_children():
			if child.id == key:
				child.queue_free()


func _on_chop_tree(dmg: int):
	var tile_vec: Vector2i = tilemap.local_to_map(tilemap.get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile = farm_dic.get(key)

	if not tile:
		return

	if tile["use"] == "plant" and check_harvestable_tile(tile):
		var seed_res = get_resource(tile["seed"])
		tile["hp"] -= dmg

		if tile["hp"] <= 0:
			# Add product to inventory
			for item in seed_res.product:
				var ran_output = random_output(item.amount, tile)
				InventoryEvents.emit_signal("on_add_item", item.res, ran_output)

			for child in get_children():
				if child.id == key:
					child.kill()
					break
		else:
			farm_dic[key] = tile

			for child in get_children():
				if child.id == key:
					child.chop()
					break
		# remove crop scene after harvest


func _on_build_barn():
	var tile_vec: Vector2i = tilemap.local_to_map(tilemap.get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile = farm_dic.get(key)

	if not tile:
		tile = {}
		tile["use"] = "build"
		farm_dic[key] = tile
		BetterTerrain.set_cell(tilemap, 1, tile_vec, 0)


# Nếu ô đã được tưới nước hoặc trồng, thì set tile đã tưới
func set_cell_watered(pos: Vector2i, status: String):
	match status:
		"Full":
			tilemap.set_cell(farming_layer, pos, land_tile_id, Vector2i(1, 0), 0)
		"Short":
			tilemap.set_cell(farming_layer, pos, land_tile_id, Vector2i(2, 0), 0)


func set_cell_builded(pos: Vector2i):
	BetterTerrain.set_cell(tilemap, 1, pos, 0)


# sinh crop scene
func spawn_crop_node(pos: Vector2i, seed_name: String, start_time: int):
	var id = "{0},{1}".format([pos.x, pos.y])

	var obj_scene: Crop = crop_scene.instantiate()
	entity.add_child(obj_scene)
	obj_scene.position = tilemap.map_to_local(pos)
	obj_scene.id = id

	var seed_res = get_resource(seed_name)
	var sprite_frames = get_sprite_frames(seed_name)

	obj_scene.setup(start_time, seed_res.time_range, sprite_frames, seed_res.harvest_action)


# key have the form "{10},{20}"
func key_to_vecter(key: String) -> Vector2i:
	var arr = key.split(",")
	return Vector2i(int(arr[0]), int(arr[1]))


# Dùng để lấy tên của tile hiện tại
func get_sprite_frames(sprite_name: String) -> SpriteFrames:
	return load("res://scenes/resources/tree_animation/" + sprite_name + ".tres")


# return seed resource from name
func get_resource(seed_name: String) -> SeedItem:
	return load("res://scenes/inventory/item/seeds/" + seed_name + ".tres")


func set_tile_planted(tile: Vector2i):
	tilemap.set_cell(farming_layer, tile, land_tile_id, Vector2i(1, 0), 0)


# kiểm tra 1 tile có thể thu hoạch hay chưa
# tile in farm_dic
func check_harvestable_tile(tile: Dictionary) -> bool:
	if not tile:
		return false
	var current_time = Time.get_unix_time_from_system()
	if tile["use"] == "plant":
		var start_time = tile["start_time"]
		var seed_res = get_resource(tile["seed"])
		if current_time >= start_time + seed_res.time_range:
			return true
	return false


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


func _input(event):
	if event is InputEventMouseButton:
		# if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		# 	_on_add_tree(pine_tree_res)

		if event.button_index == MOUSE_BUTTON_MIDDLE and event.is_pressed():
			print_debug(farm_dic)
