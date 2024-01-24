extends Animal
class_name Pig

func _process(_delta):
	if velocity <= Vector2.ZERO:
		animated.flip_h = true
	else:
		animated.flip_h = false
