extends Node
class_name CompleteTimer

# UNIX time
@export var start_time: float = 0

# Seconds
@export var completed_time: float = 0

var current_time: float

var timer: Timer

signal done

signal timeout(value: float)

var is_start: bool = false


func _ready():
	timer = Timer.new()
	timer.wait_time = 1
	timer.timeout.connect(_on_timer_timeout)

	add_child(timer)


func start():
	current_time = 0
	if current_time < 0 or current_time >= completed_time:
		done.emit()
		return

	timer.start()


func resume():
	pass


func _on_timer_timeout():
	current_time += 1
	timeout.emit(completed_time - current_time)

	if current_time >= completed_time:
		done.emit()
		timer.stop()
