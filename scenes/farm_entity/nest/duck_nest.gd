extends Nest
class_name DuckNest


func _ready():
	FarmEvents.connect("on_add_duck_egg", _on_add_egg)
