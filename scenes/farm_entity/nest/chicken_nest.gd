extends Nest
class_name ChickenNest


func _ready():
	FarmEvents.connect("on_add_chicken_egg", _on_add_egg)
