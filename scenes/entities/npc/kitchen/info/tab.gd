extends TabContainer


func _ready():
	set_tab_title(0, "Chi tiết")
	set_tab_title(1, "Đang nấu")

	current_tab = 0
