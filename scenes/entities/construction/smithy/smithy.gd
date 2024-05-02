extends Node2D
class_name Smithy

@export var inventory: Inventory

func start():
	pass

func finished_upgrading(tool: InventoryItem, level: int):
	var res = load("res://inventory/db/items/" + tool.name + "_" + str(level) + ".tres")

	inventory.add_item(res, 1)
