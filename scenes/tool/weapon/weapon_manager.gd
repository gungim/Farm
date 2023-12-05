extends Node2D
class_name WeaponManager

@onready var weapons: Array[Tool] =[
		$SwordBig,
		$Axe
	]
@onready var player: Player
var current_weapon: Tool = null;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("mouse_right"):
			if current_weapon:
				attack()

func use_weapon2():
	for item in weapons:
		item.unuse()
	current_weapon.use()

func attack():
	current_weapon.attack()
