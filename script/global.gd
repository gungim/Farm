extends Node

enum tool_actions { CHOP = 11, ATTACK = 12, HOE = 13, HARVEST = 14, WATERING = 15 }
enum product_actions { FOOD = 17, BUILD = 18, BURN = 19, COOKING = 20 }

func format_time(secs: int) -> String:
	var hours = floor(secs / float(60 * 60))
	var divisor_for_minutes = secs % (60 * 60)
	var minutes = floor(divisor_for_minutes / float(60))
	var divisor_for_seconds = divisor_for_minutes % 60
	var seconds = ceil(divisor_for_seconds)

	hours = hours if hours >= 10 else "0" + str(hours)
	minutes = minutes if minutes >= 10 else "0" + str(minutes)
	seconds = seconds if seconds >= 10 else "0" + str(seconds)

	return "{0}:{1}:{2}".format([hours, minutes, seconds])
