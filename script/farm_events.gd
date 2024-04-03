extends Node

# Signal called when player hoe
signal on_hoe(pos: Vector2)
signal on_watering
signal on_add_chicken_egg(amount: int)
signal on_add_duck_egg(amount: int)
signal on_build_barn

# Emit when item in menu of kitchen menu clicked
signal kitchen_select_item(item: KitchenRecipe)

# Emit when button start cooking clicked
signal start_cooking(item: KitchenRecipe)

var farm_dic = {}
