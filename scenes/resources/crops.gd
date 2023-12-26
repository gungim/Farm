extends Area2D
class_name Crops

var stages: Array[int] = []

var can_harvest: bool = false

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var time_label: Label = $Label

# Unit seconds
# min=0
@export var completed_time: float = 120
var current_secs: int = 0

func _ready():
	stages = [0, completed_time / 3, completed_time * 2 / 3, completed_time]
	time_label.visible = false

func setup(start_time):
	if start_time:
		var current_time = Time.get_datetime_dict_from_system()
		current_secs = (current_time["day"] - start_time["day"])*60*60*60  + (current_time["hour"]-start_time["hour"])*60*60  + (current_time["minute"]-start_time["minute"])* 60 +(current_time["second"]- start_time["second"])
	else:
		current_secs = completed_time
	timer.start()

func _on_timer_timeout():
	current_secs -= 1
	time_label.text  = format_time(current_secs)
	if current_secs >= completed_time or current_secs <= stages[0]:
		timer.stop()
		animated.play('4')
		time_label.text = ''
	elif current_secs <= stages[1]:
		animated.play("3")
	elif  current_secs <= stages[2]:
		animated.play("2")
	else:
		animated.play("1")

func format_time(secs: int)-> String:
	var hours = floor(secs / (60 * 60));
	var divisor_for_minutes = secs % (60 * 60);
	var minutes = floor(divisor_for_minutes / 60);
	var divisor_for_seconds = divisor_for_minutes % 60;
	var seconds = ceil(divisor_for_seconds);
	
	return"{0}:{1}:{2}".format([hours, minutes, seconds]);

func test():
	var start_time_test = {
		"year": 2023,
		"month": 12,
		"day": 25,
		"weekday": 1,
		"hour": 16,
		"minute": 23,
		"second": 29, 
		"dst": false 
	}
	
	setup(start_time_test)


func _on_mouse_entered():
	time_label.visible = true

func _on_mouse_exited():
	await get_tree().create_timer(3.).timeout
	time_label.visible = false
