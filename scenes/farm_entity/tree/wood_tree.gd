# Không sử dụng hàm _ready
# Sử dụng hàm _setup thay thể hàm _ready
extends FarmTree
class_name WoodTree

var farm_type: String = "chop"


# Hàm này sử dụng để thực hiện việc thu hoạch
# TODO: chức năng thu hoạch cây thân gỗ
func harvest(dmg: int):
	if dmg > 0:
		HP -= dmg

	if HP <= 0:
		kill()
