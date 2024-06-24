extends FarmTree
class_name CropTree


func _help_ready():
	harvest_type = HarvestType.HAND


func _on_mouse_exited():
	await get_tree().create_timer(3.).timeout


# TODO: chức năng thu hoạch cây nông nghiệp
func _harvest(_dmg: int):
	kill()
