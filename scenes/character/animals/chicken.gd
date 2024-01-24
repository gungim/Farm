extends Animal
class_name Chicken

# Timer cho thời gian đẻ trứng
@onready var egg_timer: Timer = $EggTimer


func _ready():
	egg_timer.wait_time = 10800


func _process(_delta):
	print_debug(velocity)
	if velocity <= Vector2.ZERO:
		animated.flip_h = true
	else:
		animated.flip_h = false


func _start_create_product():
	egg_timer.start()


func _on_egg_timer_timeout():
	FarmEvents.emit_signal("on_add_chicken_egg", 1)
