extends Resource
class_name RecipeDB

@export var slots: Array[Recipe] = []

@export var amount: int = 40


func setup():
	var obj = Recipe.new()
	if slots.size() < amount:
		for i in amount - slots.size():
			slots.push_back(obj)
