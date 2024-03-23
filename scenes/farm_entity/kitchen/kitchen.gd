extends Node2D
class_name Kitchen

@onready var chef: Chef = $Chef
@onready var menu: KitchenMenu = $CanvasLayer/KitchenMenu


func _ready():
	menu.visible = false


func open_menu():
	menu.visible = true


func setup():
	pass
