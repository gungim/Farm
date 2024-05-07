extends MarginContainer
class_name KitchenCooking

@onready var grid: GridContainer = $GridContainer


func setup():
	pass


func add_thread(item: Cooking):
	grid.database.add(item)
