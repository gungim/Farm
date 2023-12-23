extends Node2D
class_name Equipment

var slot: Slot
@onready var label: TextureRect =  $TextureRect
@onready var animated: AnimationPlayer = $AnimationPlayer

func _ready():
	update_item(null)

func update_item(value: Slot):
	slot = value
	spawn_item()

func spawn_item():
	if slot and slot.item:
		label.texture = slot.item.icon
		animated.play("Use")
	else:
		label.texture = null
		animated.stop()
