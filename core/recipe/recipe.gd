extends Resource
class_name Recipe

@export var name: String
@export var display_name: String
@export var description: String
@export var icon: Texture
@export var ingredients: Array[Slot]
@export var time: float
@export var finished_product: InventoryItem
