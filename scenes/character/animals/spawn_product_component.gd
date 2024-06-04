extends Node
class_name SpawnProductComponent

@onready var timer: Timer = $Timer

@export var wait_time: int = 2  #seconds
@export var stored: String

@export var started: bool = false


func _ready():
	timer.wait_time = wait_time * 60
	timer.autostart = false
	if started:
		_start()


func _start():
	timer.start()
	started = true


func _on_timer_timeout():
	if stored != "":
		var node = get_tree().get_first_node_in_group(stored)
		if node.has_method("add_product"):
			print_debug("Add chicken egg")
			node.add_product(1)
