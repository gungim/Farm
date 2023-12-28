extends Node

var allow_orther_action = true

# Signal called when item used(on hotbar)
signal on_use_item(item)
signal on_hold_item(item)
signal on_cancel_all_action
