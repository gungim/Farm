extends Nest
class_name ChickenNest


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			print("chicken nest Click!")
