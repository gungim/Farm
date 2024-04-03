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




func _on_mouse_entered():
	print_debug("Enter")
	time_label.visible = true


func _on_mouse_exited():
	await get_tree().create_timer(3.).timeout
	time_label.visible = false


func _harvest():
	if not player:
		return

	if not check_completed():
		return

	var player_can_harvest = player.check_farm_state("harvest")
	if player_can_harvest == 0:
		player.play_animation("harvest")
		kill()
