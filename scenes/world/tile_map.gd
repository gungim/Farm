extends TileMap

var mouse_layer: int = 2
var select_cell_tile_id = 1


func _ready():
	pass


func _input(event):
	if event is InputEventMouseMotion:
		clear_layer(mouse_layer)
		var pos: Vector2 = local_to_map(get_global_mouse_position())
		set_cell(mouse_layer, pos, select_cell_tile_id, Vector2i(0, 0), 0)
