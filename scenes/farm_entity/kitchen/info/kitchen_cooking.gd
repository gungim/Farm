extends MarginContainer
class_name KitchenCooking

var remaining_time: int = 0

@onready var time_label: Label = $VBoxContainer/RemainingLabel

@onready var timer: Timer = $Timer

@onready var done_button: Button = $VBoxContainer/HBoxContainer/Button


func _ready():
	timer.wait_time = 1
	done_button.visible = false
	FarmEvents.connect("cooking_finished", _on_cooking_finished)


func update(cooking: Cooking):
	if cooking:
		var recipe = cooking.recipe
		$VBoxContainer/RecipeIcon/TextureRect.texture = recipe.icon
		$VBoxContainer/RecipeName.text = recipe.display_name

		remaining_time = (
			(recipe.cooking_time + cooking.start_time) - Time.get_unix_time_from_system()
		)
		if remaining_time <= 0:
			time_label.text = "Hoàn thành"
		else:
			timer.start()
	else:
		$VBoxContainer/RecipeIcon/TextureRect.texture = null
		$VBoxContainer/RecipeName.text = ''
		time_label.text = ""
		done_button.visible = false
		timer.stop()


func _on_timer_timeout():
	remaining_time -= 1
	time_label.text = GlobalEvents.format_time(remaining_time)

	if remaining_time <= 0:
		timer.stop()
		time_label.text = "Hoàn thành"
		done_button.visible = true


func _on_button_pressed():
	FarmEvents.emit_signal("cooking_finished")


func _on_cooking_finished():
	update(null)
