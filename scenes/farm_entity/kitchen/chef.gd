extends StaticBody2D
class_name Chef


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			owner.open_menu()
