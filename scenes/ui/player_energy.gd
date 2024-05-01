extends MarginContainer
class_name PlayerEnergy

@onready var hp_bar: ProgressBar = $VBoxContainer/HBoxContainer/HP


func _ready():
	PlayerEvents.connect("on_update_hp", _on_update_hp)


func _on_update_hp(value: int):
	print_debug(value)
	hp_bar.value = value
