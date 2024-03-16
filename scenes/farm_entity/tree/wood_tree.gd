# Không sử dụng hàm _ready
# Sử dụng hàm _setup thay thể hàm _ready
extends FarmTree
class_name WoodTree


# Hàm này sử dụng để thực hiện việc thu hoạch
func _harvest():
	if not player:
		return

	var tool_dmg = player.check_farm_state("chop")
	if tool_dmg > 0 and current_time >= completed_time:
		FarmEvents.emit_signal("on_harvested", id)
		player.play_animation("chop")
		HP -= tool_dmg

	if HP <= 0:
		kill()
