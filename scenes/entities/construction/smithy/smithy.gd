extends Node2D
class_name Smithy

@export var inventory: Inventory

var max_thread: int = 1
var current_thread: int = 0

var tool_upgrading: Recipe


func check_can_update(tool: InventoryItem) -> bool:
	if tool.properties["level"]:
		var res = load(
			(
				"res://inventory/db/items/"
				+ tool.name
				+ "_"
				+ str(tool.properties["level"] + 1)
				+ ".tres"
			)
		)
		if res:
			return true
	return false


func start_upgrade(tool: InventoryItem):
	if not check_can_update(tool):
		return

	if current_thread >= max_thread:
		return

	current_thread += 1


func finished_upgrading():
	var item: InventoryItem = tool_upgrading.finished_product

	inventory.add_item(item, 1)
