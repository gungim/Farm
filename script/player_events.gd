extends Node

var allow_other_action = true

# Signal called when item used(on hotbar)
signal on_use_item(item)
signal on_hold_item(item)
signal on_cancel_all_action

signal on_allow_other_action(value)

func _ready():
	on_allow_other_action.connect(_on_allow_other_action)

func _on_allow_other_action(value: bool):
	allow_other_action = value
