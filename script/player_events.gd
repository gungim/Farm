extends Node

# Signal called when item used(on hotbar)
signal on_use_item(item)

signal on_select_hotbar_slot(slot: Slot, index: int)

# Emit when player hp updated
signal on_update_hp(hp: int)

signal on_update_gold(value: int)

signal on_disable_player(value: bool)
