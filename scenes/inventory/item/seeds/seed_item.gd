extends InventoryItem
class_name SeedItem

# thời gian để cây lớn
@export var time_range: int = 100

# sản lượng mặc định
@export var default_output: int = 6

@export var product: Array[InventoryItem] = []

# Cách thu hoạch
# Chop = 1 -- Chặt
# default = 0
@export var harvest_action: int = 0
