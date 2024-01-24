extends FSM


func _init():
	_add_state("idle")
	_add_state("random_move")
	_add_state("move_to_pos")
	_add_state("eat")


func _ready():
	set_state(states.idle)


func _state_logic(_detal: float) -> void:
	if state == states.move_to_pos:
		owner.move()
		owner.move_to_pos()
	elif state == states.random_move:
		owner.move()


func _get_transition() -> int:
	match state:
		states.move_to_pos:
			if owner.velocity.length() < 10:
				return states.idle
		states.eat:
			if owner.HP == owner.MAX_HP:
				owner.state_timer.start()
				return states.random_move
		states.random_move:
			if owner.velocity.length() < 10:
				return states.idle

	return -1


func _enter_state(_prev: int, _new: int) -> void:
	match state:
		states.random_move:
			animation_player.play("Move")
		states.idle:
			animation_player.play("Idle")
		_:
			animation_player.play("Move")


func random_state() -> int:
	var cop_states = states
	if owner.HP >= owner.MAX_HP / 3:
		cop_states.erase(cop_states.eat)
	cop_states.erase(cop_states.move_to_pos)

	var key: String = cop_states.keys()[randi() % cop_states.size()]
	return states[key]
