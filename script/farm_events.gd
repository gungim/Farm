extends Node

# Signal called when player hoe
signal on_hoe(pos: Vector2)
signal on_watering
signal on_add_chicken_egg(amount: int)
signal on_add_duck_egg(amount: int)

# Build farm construction
signal on_build_fence
signal on_build_gate

var farm_dic = {}
