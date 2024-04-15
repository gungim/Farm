# Không sử dụng hàm _ready
# Sử dụng hàm _setup thay thể hàm _ready
extends FarmTree
class_name WoodTree

var farm_state: String = "chop"

# Hàm này sử dụng để thực hiện việc thu hoạch
func _harvest():
	if not player:
		return

	var tool_dmg = player.check_farm_state(farm_state)
	if tool_dmg > 0 and check_completed():
		player.play_animation(farm_state)
		HP -= tool_dmg

	if HP <= 0:
		kill()

