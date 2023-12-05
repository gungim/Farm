extends FSM

signal  move_to_tile

func _init():
	_add_state("idle")
	_add_state("move")
	_add_state("move_to_tile")

func _ready():
	animation_player = owner.get_node("AnimationPlayer")
	set_state(states.move)
	connect("move_to_tile", _on_move_to_tile)

func _state_logic(_delta: float)->void:
	if state == states.idle or  state == states.move:
		owner.get_input()
		owner.move()
	if state == states.move_to_tile:
		owner.move_to_tile()
		owner.move()

func _get_transition() -> int:
	match  state:
		states.idle:
			if owner.velocity.length() > 10:
				return states.move
		states.move:
			if owner.velocity.length() < 10:
				return states.idle
		states.move_to_tile:
			if owner.velocity.length() < 10:
				return states.idle
	return -1

func _enter_state(_previus_state: int, _new_state: int)-> void:
	match state:
		states.idle:
			animation_player.play("Idle")
		states.move:
			animation_player.play("Move")
		states.move_to_tile:
			animation_player.play("Move")
		
func _on_move_to_tile():
	set_state(states.move_to_tile)
