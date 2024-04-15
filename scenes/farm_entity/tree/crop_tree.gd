extends FarmTree
class_name CropTree


func _on_mouse_exited():
	await get_tree().create_timer(3.).timeout


func _harvest():
	if not player:
		return

	if not check_completed():
		return

	var player_can_harvest = player.check_farm_state("harvest")
	if player_can_harvest == 0:
		player.play_animation("harvest")
		kill()
