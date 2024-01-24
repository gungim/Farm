extends TileMap
class_name FarmTileMap

enum ACTIONS { HOE, PLANT, WATERING, FOOD, HARVEST }

# farming layer
var farming_layer: int = 0

var land_tile_id: int = 0

@onready var crop_scene = preload("res://scenes/farm_entity/crops/crops.tscn")
@onready var pine_tree_res = preload("res://scenes/resources/tree_animation/pine.tres")

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
	setup()


func setup():
	for key in farm_dic:
		var tile_vec: Vector2i = key_to_vecter(key)
		var tile = farm_dic[key]
		if tile:
			set_tile_planted(tile_vec)

		if tile["planted"]:
			# spawn crop scene and add to current tile
			var obj_scene: Crop = crop_scene.instantiate()
			add_child(obj_scene)
			obj_scene.position = map_to_local(tile_vec) - Vector2(0, 5)
			obj_scene.id = key

			var seed_res = get_resource(tile["seed"])
			var sprite_frames = get_sprite_frames(tile["seed"])

			obj_scene.setup(
				tile["start_time"], seed_res.time_range, sprite_frames, seed_res.harvest_action
			)

		# Update water status
		var water_status = tile.get("water_status")
		set_cell_water_tile(tile_vec, water_status)


func _on_hoe():
	var tile_vec: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile = farm_dic.get(key)
	if not tile:
		set_tile_planted(tile_vec)
		farm_dic[key] = {"planted": false, "water_status": "Short"}


func _on_watering():
	var tile_vec: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile = farm_dic.get(key)
	if tile:
		set_cell_water_tile(tile_vec, "Full")
		tile["water_status"] = "Full"
		farm_dic[key] = tile


# @params seed_slot: is seed resource
func _on_plant(seed_slot: Slot):
	if not seed_slot or not seed_slot.item:
		return

	var tile_vec: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile = farm_dic.get(key)

	if tile and not tile["planted"]:
		if seed_slot.item is SeedItem and seed_slot.amount > 0:
			var start_time = Time.get_unix_time_from_system()
			set_tile_planted(tile_vec)

			# Update type to PLANTED and set seed type, start_time
			tile["planted"] = true
			tile["seed"] = seed_slot.item.resource_name
			tile["start_time"] = start_time
			tile["hp"] = 100
			farm_dic[key] = tile

			# Spawn crop scene at tile vec
			var obj_scene: Crop = crop_scene.instantiate()
			var seed_res = get_resource(tile["seed"])
			var sprite_frames = get_sprite_frames(tile["seed"])
			add_child(obj_scene)
			obj_scene.setup(start_time, seed_res.time_range, sprite_frames, seed_res.harvest_action)
			obj_scene.position = map_to_local(tile_vec) - Vector2(0, 5)
			obj_scene.id = key

			# Update inventory when plant success
			seed_slot.amount -= 1
			InventoryEvents.emit_signal("on_update_slot", seed_slot)


func _on_add_tree(tree: Resource):
	var tile_vec: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile = farm_dic.get(key)

	if not tile:
		tile = {}
		tile["planted"] = true
		tile["seed"] = tree.resource_name
		tile["start_time"] = 00
		tile["hp"] = 100
		farm_dic[key] = tile

		var obj_scene: Crop = crop_scene.instantiate()
		var sprite_frames = tree
		add_child(obj_scene)
		obj_scene.setup(00, 00, sprite_frames, 1)
		obj_scene.position = map_to_local(tile_vec) - Vector2(0, 5)
		obj_scene.id = key

		set_tile_planted(tile_vec)


func _on_harvest_crops():
	var tile_vec: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile = farm_dic.get(key)

	if tile and check_harvestable_tile(tile):
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
	var tile_vec: Vector2i = local_to_map(get_global_mouse_position())
	var key = "{0},{1}".format([tile_vec.x, tile_vec.y])
	var tile = farm_dic.get(key)

	if tile and check_harvestable_tile(tile):
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

func set_cell_water_tile(tile_vec, status):
	match status:
		"Full":
			set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(1, 0), 0)
		"Short":
			set_cell(farming_layer, tile_vec, land_tile_id, Vector2i(2, 0), 0)


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
	set_cell(farming_layer, tile, land_tile_id, Vector2i(1, 0), 0)


# kiểm tra 1 tile có thể thu hoạch hay chưa
# tile in farm_dic
func check_harvestable_tile(tile: Dictionary) -> bool:
	if not tile:
		return false
	var current_time = Time.get_unix_time_from_system()
	if tile and tile["planted"]:
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
