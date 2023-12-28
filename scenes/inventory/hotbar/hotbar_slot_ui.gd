extends SlotUI
class_name HotbarSlotUI

signal on_select

func _ready():
	$NinePatchRect.visible = false

func selected():
	$NinePatchRect.visible = true

func unselect():
	$NinePatchRect.visible = false

func _on_mouse_exited():
	PlayerEvents.allow_orther_action = true


func _on_mouse_entered():
	PlayerEvents.allow_orther_action = false
