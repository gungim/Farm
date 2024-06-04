extends Node
class_name SpawnProductComponent

@onready var timer: Timer = $Timer

@export var wait_time: int = 2  #seconds
@export var stored: String

var stored_node: Node

@export var started: bool = false


func _ready():
	timer.wait_time = wait_time
	timer.autostart = false

	if stored != "":
		stored_node = get_tree().get_first_node_in_group(stored)

	if started:
		_start()


func _start():
	if stored_node:
		timer.start()
		started = true
	else:
		print_debug("Can't find stored " + stored)


func _on_timer_timeout():
	if stored_node.has_method("add_product"):
		stored_node.add_product(1)
