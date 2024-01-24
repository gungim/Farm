extends StaticBody2D
class_name Nest

@onready var egg_amount: int = 0


func setup(amount):
	egg_amount = amount


func _on_add_egg(amount: int):
	egg_amount += amount
