extends StaticBody2D
class_name Chef

@onready var player: Player


func _ready():
	player = get_tree().get_first_node_in_group("Player")


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if player.position.distance_to(position) <= 64:
			if event.button_index == MOUSE_BUTTON_LEFT:
				owner.open_menu()
