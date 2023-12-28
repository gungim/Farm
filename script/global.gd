extends Node

func time_to_second(t: Dictionary) -> int:
	var kq = t["day"]*60*60*60 + t["hour"]*60*60  + t["minute"]* 60 +t["second"]
	return kq
