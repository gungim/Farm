extends Node2D
class_name Trough

var amount: int = 0

var level = 1


func _ready():
	pass


func decrement():
	amount -= 1


func add_food():
	amount = 100
