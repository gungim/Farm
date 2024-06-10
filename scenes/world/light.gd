extends Node

class_name Light

@onready var direction_light: DirectionalLight2D = $DirectionalLight2D
@onready var animated: AnimationPlayer = $AnimationPlayer


func light():
	pass


func lights(value: bool):
	get_tree().call_group("LightSource", "enable", value)


func animal_sleep(value: bool):
	get_tree().call_group("Animal", "sleep", value)
