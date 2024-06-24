extends StaticBody2D
class_name HoePlace

@onready var player: Player
@onready var effect: AnimatedSprite2D = $EffectSprite
@onready var sprite: Sprite2D = $Sprite2D
@onready var water_timer: Timer = $WaterTimer

var tree_node: FarmTree
var crop: Crop

var planted: bool = false

# max = 100
# min = 0
var water_value: int = 100:
	get:
		return water_value
	set(value):
		if value > 100:
			water_value = 100
		if value < 0:
			water_value = 0
		water_value = value


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	input_pickable = true
	water_timer.wait_time = 10
	water_timer.start()
	effect.hide()


func _plant():
	if not player.current_slot:
		return

	crop = player.get_item_property("crop")
	_create_plant_node()
	effect.play("Planted")


func _create_plant_node():
	var plant_scene: PackedScene

	match crop.type:
		Crop.CROP_TYPE.AGRICULTURE:
			plant_scene = load("res://scenes/farm_entity/tree/crop_tree.tscn")
		Crop.CROP_TYPE.FORESTRY:
			plant_scene = load("res://scenes/farm_entity/tree/wood_tree.tscn")

	var start_time = Time.get_unix_time_from_system()

	var node: FarmTree = plant_scene.instantiate()
	node.time_label_visible = true

	add_child(node)
	node.setup(start_time, crop, 100)
	tree_node = node

	planted = true

	player.decrement_current_slot()


func watering():
	effect.play("Watering")
	sprite.frame = 3
	water_value = 100


func harvested():
	effect.play("Harvested")
	player.cancel_animation()
	planted = false
	water_timer.stop()
	_add_product_to_inventory()


func _input_event(_viewport, event, _shape_idx):
	if not player:
		return
	if global_position.distance_to(player.global_position) >= 32:
		return

	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if player.check_item_by_category("seed"):
				_plant()
			elif player.check_item_by_category("tool"):
				var player_action = player.get_item_property("action_type")
				match player_action:
					"watering":
						watering()
					"harvest":
						if tree_node and tree_node.can_harvest:
							var harvest_type = tree_node.harvest_type
							match harvest_type:
								FarmTree.HarvestType.CHOP:
									var tool_dmg = player.get_item_property("damage")
									player.play_animation("HarvestChop")
									if not tool_dmg:
										tool_dmg = 1
									tree_node.harvest(tool_dmg)
								FarmTree.HarvestType.HAND:
									player.play_animation("HarvestHand")
									tree_node.harvest(100)
					_:
						pass


func _on_water_timer_timeout():
	water_value -= 1
	if water_value >= 70:
		sprite.frame = 3
	elif water_value >= 30:
		sprite.frame = 2
	else:
		sprite.frame = 1
		if water_value <= 0:
			water_timer.stop()


func _add_product_to_inventory():
	var products: CropProducts = crop.products
	if not products:
		return

	for slot in products.items:
		InventoryEvents.emit_signal("add_item", slot.item, slot.amount)
	crop = null
