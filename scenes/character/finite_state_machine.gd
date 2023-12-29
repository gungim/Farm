extends Node
class_name FSM

var states: Dictionary = {}
var previus_state: int = -1
var state: int = -1:
	set(value):
		state = value
	get:
		return state
@onready var animation_player: AnimationPlayer = owner.get_node("AnimationPlayer")


func _physics_process(delta):
	if state != -1:
		_state_logic(delta)
		var transition: int = _get_transition()
		if transition != -1:
			set_state(transition)


func _state_logic(_delta: float) -> void:
	pass


func _get_transition() -> int:
	return -1


func set_state(new_state: int) -> void:
	_exit_state(state)
	previus_state = state
	state = new_state
	_enter_state(previus_state, state)


func _enter_state(_previus_state: int, _new_state: int) -> void:
	pass


func _exit_state(_state_exited: int) -> void:
	pass


func _add_state(new_state: String) -> void:
	states[new_state] = states.size()
