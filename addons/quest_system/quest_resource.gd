@icon("./assets/quest_resource.svg")
extends Resource
class_name Quest

@export var id: int
@export var quest_name: String
@export_multiline var quest_description: String
@export_multiline var quest_objective: String

# Bổ sung
@export var reward: Array[Reward]
@export var prized_money: int

signal started
signal updated
signal completed

var objective_completed: bool = false:
	set(value):
		objective_completed = value
	get:
		return objective_completed

func update() -> void:
	updated.emit()

func start() -> void:
	started.emit()

func complete() -> void:
	completed.emit()
