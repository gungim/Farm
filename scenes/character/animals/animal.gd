extends Character
class_name Pig

@onready var energy_timer: Timer = $EnergyTimer
@onready var state_timer: Timer = $StateTimer
@onready var live_timer: Timer = $LiveTimer
@onready var eat_timer: Timer = $EatTimer

@export var live_time: int = 259200

var start_live_time: int = 1705879128
var current_live_time: int = 259200
var target: Vector2 = Vector2.ZERO
var next_state: int = -1


func _ready():
	energy_timer.wait_time = 30
	state_timer.wait_time = 10  # 20
	live_timer.wait_time = 1

	energy_timer.start()
	state_timer.start()
	live_timer.start()


func setup(start_time: int):
	start_live_time = start_time


func move_to_pos():
	if position.distance_to(target) > 16:
		mov_direction = position.direction_to(target)
	else:
		match next_state:
			fsm.states.eat:
				eat()


func move_to_feeding_trough(pos: Vector2):
	target = pos
	fsm.set_state(fsm.states.move_to_pos)


func _on_energy_timer_timeout():
	HP -= 1
	if HP <= 10:
		energy_timer.stop()
		state_timer.stop()

		var trough = get_tree().get_nodes_in_group("Trough")
		var target_pos: Vector2 = trough[0].position
		var target_dis: float = position.distance_to(target_pos)

		for child in trough:
			var child_dis: float = position.distance_to(child.position)
			if child_dis < target_dis:
				target_pos = child.position
				target_dis = child_dis

		move_to_feeding_trough(target_pos)
		# next action not next state
		next_state = fsm.states.eat


func _on_state_timer_timeout():
	var new_state = fsm.random_state()

	fsm.set_state(new_state)
	random_direction()


func random_direction():
	var val1 = randf_range(-1, 1)
	var val2 = randf_range(-1, 1)

	mov_direction = Vector2(val1, val2)


func _on_live_timer_timeout():
	var current_time = int(Time.get_unix_time_from_system() - start_live_time)
	if current_time <= 0:
		die()


func eat():
	mov_direction = Vector2.ZERO
	target = Vector2.ZERO
	fsm.set_state(fsm.states.eat)
	eat_timer.start()


func die():
	queue_free()


func generates_items():
	pass


func _on_eat_timer_timeout():
	HP += 1

	if HP == MAX_HP:
		next_state = fsm.states.random_move
		state_timer.start()
		energy_timer.start()
		eat_timer.stop()
