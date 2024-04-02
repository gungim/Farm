extends MarginContainer
class_name KitchenItemInfo

@onready var item_scene = load("res://scenes/farm_entity/kitchen/kitchen_item.tscn")

@onready var raw_material_grid: InventoryItemGrid = $VBoxContainer/GridContainer

@onready var title: Label = $VBoxContainer/Label
@onready var recipe_texture: TextureRect = $VBoxContainer/TextureButton/RecipeIcon


func _ready():
	FarmEvents.connect("kitchen_select_item", _kitchen_select_item)
	visible = false


func _kitchen_select_item(item: KitchenRecipe):
	raw_material_grid.inventory.clear()
	raw_material_grid.reset()

	if item:
		visible = true

		title.text = "Weo, bạn muốn nấu món " + item.display_name + " ư"
		recipe_texture.texture = item.icon

		raw_material_grid.inventory.amount = item.ingredients.size()
		raw_material_grid.setup_inventory()

		for raw_material_item in item.ingredients:
			raw_material_grid.inventory.add_item(raw_material_item, 1)

