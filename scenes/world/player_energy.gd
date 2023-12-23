extends Control
class_name PlayerEnergy

@onready var hp_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/HP

func _ready():
	UiEvents.connect("update_hp_label", _update_hp_label)

func _update_hp_label(value: int):
	hp_bar.value = value
