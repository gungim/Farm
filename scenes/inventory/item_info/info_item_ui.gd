extends VBoxContainer

func set_value(key, value):
	$KeyLabel.text = key
	$MarginContainer/ValueLabel.text = value
