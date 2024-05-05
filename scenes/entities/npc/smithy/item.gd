extends Button
class_name SmithySlotUI


func update_info(item: Recipe):
	if item:
		icon = item.icon
		text = item.display_name
	else:
		icon = null
		text = ""
