extends CharacterBody2D
class_name Character

var FRICTION = 0.15
var can_move: bool = true

@export var MAX_SPEED = 100
@export var MAX_HP = 100
@export var ACCELERATION = 40
@export var HP: int = 10
# Get the gravity from the project settings to be synced with RigidBody nodes.

var mov_direction: Vector2  = Vector2.ZERO
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var fsm: FSM = $FiniteStateMachine

func move():
	if can_move:
		mov_direction = mov_direction.normalized()
		velocity += mov_direction * ACCELERATION
		velocity = velocity.limit_length(MAX_SPEED) 
		velocity = lerp(velocity, Vector2.ZERO, FRICTION)
		move_and_slide()

func change_hp(value: int):
	HP = value
	if HP >= MAX_HP:
		HP = MAX_HP
