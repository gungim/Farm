extends Resource
class_name InventoryItem
## Definition of an inventory item
##
## This information will be stored in slots within the [Inventory]
## The [InventoryDatabase] must be used to link items with an identifier.
## This script is meant to be expanded to contain new information, example:
## FoodItem containing information about how much food satisfies hunger
## Usage:
## [codeblock]
## 	extends InventoryItem
## 	class_name FoodItem
##
## 	@export var satisfies_hunger = 12
## [/codeblock]
## Maximum amount of this item within an [Inventory] slot
@export var max_stack := 0

@export var name: String

##
@export var display_name: String

## Item icon in texture2D, displayed by [SlotUI]
@export var icon: Texture2D

## Item weight in float
@export var weight: int

## Item custom properties
## type of item: tool, weapon, seed, food
@export var properties: Dictionary = {}

@export_multiline var description: String

@export var categories: Array[Category]
