extends Resource
class_name KitchenRecipe

@export var name: String
@export var display_name: String
@export var description: String
@export var icon: Texture
@export var ingredients: Array[InventoryItem]
@export var cooking_time: int
@export var finished_product: InventoryItem
