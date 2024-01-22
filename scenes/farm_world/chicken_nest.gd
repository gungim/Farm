extends StaticBody2D
class_name ChickenNest

@export var chicken_amount: int = 0
var egg_amount: int = 0


func setup(e_am: int, c_am: int):
	egg_amount = e_am
	chicken_amount = c_am
