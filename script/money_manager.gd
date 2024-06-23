extends Node

@onready var ui_manager: Node

var value: int = 0


func _ready():
	pass


func add_money(amount: int):
	value += amount
