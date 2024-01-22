extends InventoryItem
class_name SeedItem

# thời gian để cây lớn
@export var time_range: int = 100

# Dictionary {res: product res(InventoryItem), amount: int}
@export var product: Array[Dictionary] = []

# Cách thu hoạch
# Chop = 1 -- Chặt
# default = 0
@export var harvest_action: int = 0
