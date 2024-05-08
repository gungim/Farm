extends Node2D
class_name NPC

@onready var menu: Control = $CanvasLayer/Control
@onready var player: Player
@onready var npc: StaticBody2D = $StaticBody2D

@export var active_dialogue: bool = false


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	menu.visible = false


func _on_static_body_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if player.position.distance_to(npc.global_position) <= 64:
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				if active_dialogue:
					open_dialogue()
					active_dialogue = false
				else:
					open_menu()


func open_dialogue():
	pass

func open_menu():
	menu.visible = true
	InventoryEvents.emit_signal("on_open_inventory", true)


func _on_texture_button_pressed():
	menu.visible = false
	InventoryEvents.emit_signal("on_open_inventory", false)
