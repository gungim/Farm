extends Node
class_name SpawnEggComponent

@onready var timer: Timer = $Timer

@export var wait_time: int = 2  #seconds
@export var stored: String


func _ready():
	timer.wait_time = wait_time * 60
	if owner.has_method("check_can_create_product"):
		timer.start()


func _on_timer_timeout():
	if stored != "":
		var node = get_tree().get_first_node_in_group(stored)
		node.add_product(1)
