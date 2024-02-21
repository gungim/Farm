extends StaticBody2D
class_name Nest

@onready var product: int = 0


func add_product(amount: int):
	product += amount
