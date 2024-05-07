extends HBoxContainer
class_name CookingSlotUI

@onready var timer: CompleteTimer = $CompleteTimer
@onready var icon: Button = $IconButton
@onready var ok_button: Button = $OKButton

@export var cooking: RecipeProcess

signal done_pressed
signal cancel_pressed


func _ready():
	timer.connect("done", _on_done)
	timer.connect("timeout", _on_timer_timeout)
	ok_button.disabled = true


func update_info_slot(new_slot: RecipeProcess):
	cooking = new_slot
	if cooking:
		icon.icon = cooking.recipe.icon
		icon.text = cooking.recipe.display_name
		if not timer.is_start:
			timer.start_time = Time.get_unix_time_from_system()
			timer.completed_time = cooking.recipe.time
			timer.start()
	else:
		icon.icon = null
		icon.text = ""


func _on_done():
	ok_button.text = "Hoàn thành"
	ok_button.disabled = false


func _on_done_pressed():
	done_pressed.emit()


func _on_cancel_pressed():
	cancel_pressed.emit()


func _on_timer_timeout(value: float):
	ok_button.text = GlobalEvents.format_time(value)
