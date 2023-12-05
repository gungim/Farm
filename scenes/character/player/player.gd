extends Character
class_name Player

signal change_is_farming(value: bool)

var target: Vector2 = Vector2.ZERO
var is_farming: bool = false

@onready var weapon_manager: WeaponManager = $WeaponManager

func get_input():
	mov_direction = Input.get_vector("left", "right", "up", "down")

func get_target_position():
	target = get_global_mouse_position()
	fsm.emit_signal("move_to_tile")

func _process(_delta):
	if velocity <= Vector2.ZERO:
		animated.flip_h =true
		weapon_manager.rotation = 0
	else:
		animated.flip_h = false
		weapon_manager.rotation = 180

func move_to_tile():
	if position.distance_to(target) > 10:
		mov_direction = position.direction_to(target)


func _on_change_is_farming(value):
	is_farming = value
