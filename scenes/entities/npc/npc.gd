extends Node2D
class_name NPC

@onready var menu: Control = $CanvasLayer/Control
@onready var player: Player


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	menu.visible = false




func _on_static_body_2d_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event is InputEventMouseButton:
		if player.position.distance_to(position) <= 64:
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				menu.visible = true
