extends Node2D
class_name Kitchen

@onready var chef: Chef = $Chef
@onready var menu: KitchenMenu = $CanvasLayer/KitchenMenu
@onready var player: Player


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	menu.visible = false


func open_menu():
	if player.position.distance_to(position) <= 64:
		menu.visible = true


func setup():
	pass
