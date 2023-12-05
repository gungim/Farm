extends TileMap

var dic = {}
var mouse_layer: int = 2
var select_cell_tile_id = 1;

@onready var player: Player
@onready var farm_map: FarmTileMap

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	farm_map = get_tree().get_first_node_in_group("FarmMap")

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print_debug("Mouse left click tilemap")
			pass
			var player_distance_to_tile = player.position.distance_to(get_global_mouse_position())
			
	#		if player_distance_to_tile >= 32 and player.can_move:
	#			player.get_target_position()
	#		elif player_distance_to_tile < 32 and player.is_farming:
	#			farm_map.hoe()


func _input(event):
	if event is InputEventMouseMotion:
		# draw grid box
		clear_layer(mouse_layer)
		var tile: Vector2  = local_to_map(get_global_mouse_position())
		set_cell(mouse_layer, tile, select_cell_tile_id, Vector2i(0,0), 0)
