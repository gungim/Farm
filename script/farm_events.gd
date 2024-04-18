extends Node

# Signal called when player hoe
signal on_hoe(pos: Vector2)
signal on_watering
signal on_add_chicken_egg(amount: int)
signal on_add_duck_egg(amount: int)
signal on_build_barn

signal plant_tree_success
signal update_amount_slot(slot_index: int, amount: int)

# Emit when item in menu of kitchen menu clicked
signal recipe_select_item(item: KitchenRecipe)
# Emit when cooking action succes
signal start_cooking_success(recipe: KitchenRecipe)
# Emit when cooking finished
signal cooking_finished

# Emit when button start cooking clicked
signal start_cooking(item: KitchenRecipe)

var farm_dic = {}
