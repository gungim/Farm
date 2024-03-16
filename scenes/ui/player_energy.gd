extends MarginContainer
class_name PlayerEnergy

@onready var hp_bar: ProgressBar = $VBoxContainer/HBoxContainer/HP
@onready var player: Player


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if player:
		hp_bar.value = player.HP
		player.connect("updated_hp", _on_updated_hp)


func _on_updated_hp(value: int):
	hp_bar.value = value
