# Không sử dụng hàm _ready
# Sử dụng hàm _setup thay thể hàm _ready
extends FarmTree
class_name WoodTree


# Hàm này sử dụng để thực hiện việc thu hoạch
func _harvest():
	if not player:
		return

	var tool_dmg = player.check_farm_state("chop")
	if tool_dmg > 0 and check_completed():
		player.play_animation("chop")
		HP -= tool_dmg

	if HP <= 0:
		kill()

