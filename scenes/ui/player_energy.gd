extends MarginContainer
class_name PlayerEnergy

@onready var hp_bar: ProgressBar = $VBoxContainer/HBoxContainer/HP
var gold: int = 0


func _ready():
	PlayerEvents.connect("on_update_hp", _on_update_hp)
	PlayerEvents.connect("on_update_gold", _on_update_gold)


func _on_update_hp(value: int):
	hp_bar.value = value


func _on_update_gold(value: int):
	gold += value
