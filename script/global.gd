extends Node

enum tool_actions { CHOP = 11, ATTACK = 12, HOE = 13, HARVEST = 14, WATERING = 15 }
enum product_actions { FOOD = 17, BUILD = 18, BURN = 19, COOKING = 20 }


func format_time(secs: float) -> String:
	var secs_int = int(secs)
	var hours = floor(secs_int / 3600.)
	var minutes = floor(secs_int % 3600 / float(60))
	var seconds = round(secs_int % 60)

	hours = hours if hours >= 10 else "0" + str(hours)
	minutes = minutes if minutes >= 10 else "0" + str(minutes)
	seconds = seconds if seconds >= 10 else "0" + str(seconds)

	return "{0}:{1}:{2}".format([hours, minutes, seconds])
