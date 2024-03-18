extends FarmTree
class_name CropTree

@onready var time_label: Label = $Label


func _setup():
	time_label.visible = false


# func _on_timer_timeout():
# 	current_time += 1
# 	time_label.text = format_time(completed_time - current_time)

# 	if current_time > stages[-1]:
# 		animated.play(str(stages.size() - 1))
# 		time_label.text = ""
# 		timer.stop()
# 	elif current_time <= stages[1]:
# 		animated.play(str(0))
# 	else:
# 		for i in range(1, stages.size()):
# 			if current_time <= stages[i]:
# 				animated.play(str(i - 1))
# 				break


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


func _on_mouse_entered():
	print_debug("Enter")
	time_label.visible = true


func _on_mouse_exited():
	await get_tree().create_timer(3.).timeout
	time_label.visible = false


func _harvest():
	kill()
