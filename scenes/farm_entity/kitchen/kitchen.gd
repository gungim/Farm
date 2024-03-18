extends Node2D
class_name Kitchen

var cooking_recipe = [
	{
		"id": "1",
		"name": "Rice",
		"raw_material": [load("res://scenes/inventory/item/products/rice.tres")],
		"description": "Cơm"
	}
]
var is_open_menu: bool = false

@export var max_thread: int = 1

var current_thread: int = 0


func open_menu():
	is_open_menu = !is_open_menu


func start_cooking(_recipe):
	if current_thread >= max_thread:
		current_thread += 1

func check_raw_material(recipe):
	for item in recipe:
		var inventory_slot
