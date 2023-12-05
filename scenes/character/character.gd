extends CharacterBody2D
class_name Character

signal can_move(value: bool)
var FRICTION = 0.15
var is_can_move: bool = true

@export var MAX_SPEED = 100
@export var ACCELERATION = 40
@export var HP: int = 10
# Get the gravity from the project settings to be synced with RigidBody nodes.

var mov_direction: Vector2  = Vector2.ZERO
var hp: int = 0
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var fsm: FSM = $FiniteStateMachine

func _ready():
	hp = HP

func move():
	if is_can_move:
		mov_direction = mov_direction.normalized()
		velocity += mov_direction * ACCELERATION
		velocity = velocity.limit_length(MAX_SPEED) 
		velocity = lerp(velocity, Vector2.ZERO, FRICTION)
		move_and_slide()

func _on_can_move(value: bool):
	is_can_move = value
