extends Node


func time_to_second(t: Dictionary) -> int:
	var kq = t["day"] * 60 * 60 * 60 + t["hour"] * 60 * 60 + t["minute"] * 60 + t["second"]
	return kq


enum tool_actions { CHOP = 11, ATTACK = 12, HOE = 13, HARVEST = 14, WATERING = 15 }
enum product_actions { FOOD = 17 }
