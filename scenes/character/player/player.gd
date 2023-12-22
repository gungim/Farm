extends Character
class_name Player
var target: Vector2 = Vector2.ZERO
# using to check player can farm
var can_farm: bool = false

@onready var weapon_manager: WeaponManager = $WeaponManager

func _ready():
	InventoryEvents.connect("on_change_player_can_move", _on_change_player_can_move)

func _input(event):
	if event.is_action_pressed("mouse_left"):
		target = get_global_mouse_position()
		if can_move and position.distance_to(target) > 32:
			move_to_target()
		elif can_farm and position.distance_to(target) <= 32:
			FarmEvents.emit_signal("on_hoe")
		
func get_input():
	mov_direction = Input.get_vector("left", "right", "up", "down")

func _process(_delta):
	if velocity <= Vector2.ZERO:
		animated.flip_h =true
		weapon_manager.rotation = 0
	else:
		animated.flip_h = false
		weapon_manager.rotation = 180

func move_to_target():
	fsm.set_state(fsm.states.move_to_tile)
	mov_direction = position.direction_to(target)

func cancel_all_action():
	mov_direction  = Vector2.ZERO
	fsm.set_state(fsm.states.idle)

func change_is_farming(value):
	can_farm = value
	
func _on_change_player_can_move(value: bool):
	can_move = value

