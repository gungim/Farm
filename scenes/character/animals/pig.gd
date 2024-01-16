extends Character
class_name Pig

var target: Vector2 = Vector2.ZERO

@onready var energy_timer: Timer = $EnergyTimer
@onready var state_timer: Timer = $StateTimer


func _ready():
	energy_timer.wait_time = 120
	state_timer.wait_time = 20 # 20

	state_timer.start()
	energy_timer.start()

func move_to_pos():
	mov_direction = position.direction_to(target)


func move_to_feeding_trough(pos: Vector2):
	fsm.set_state(fsm.states.move_to_pos)
	target = pos


func _on_energy_timer_timeout():
	HP -= 1
	if HP <= 5:
		energy_timer.stop()
		move_to_feeding_trough(Vector2.ZERO)

func incre_hp():
	if HP == MAX_HP:
		return

	HP += 1


func _on_state_timer_timeout():
	var new_state = fsm.random_state()

	fsm.set_state(new_state)
	random_direction()

func random_direction():
	var val1 = randf_range(-1, 1)
	var val2 = randf_range(-1, 1)
	
	mov_direction = Vector2(val1, val2)

