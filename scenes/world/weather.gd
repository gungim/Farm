extends Node
class_name Weather

enum WeatherType { SPRING, SUMMER, AUTUMN, WINTER }

enum SpringType { SUN, RAIN, CLOUDY }
enum SummerType { SUN, RAIN, CLOUDY }
enum AutumnType { SUN, RAIN, CLOUDY }
enum WinterType { SNOW, RAIN }

enum RainLevel { SHOWER, DRIZZLE, STORM }
enum Level { LITTE, MEDIUM, MUCH }

var current_season: WeatherType = WeatherType.SPRING
var current_season_weather_type = SpringType
var current_type: int


func get_next_season() -> WeatherType:
	var season: WeatherType
	var date = Time.get_date_dict_from_system()
	var current_month = date.month
	var current_day = date.day

	if current_month % 2 == 0:
		if current_day >= 15:
			season = WeatherType.WINTER
		else:
			season = WeatherType.AUTUMN
	else:
		if current_day >= 15:
			season = WeatherType.SUMMER
		else:
			season = WeatherType.SPRING
	return season


func random_level() -> Level:
	var key_random = Level.keys()[randi() % Level.size()]
	return Level[key_random]


func random_type(type) -> int:
	var random_keys = type.keys()[randi() % type.size()]
	return type[random_keys]


func _ready():
	current_season = get_next_season()
	match current_season:
		WeatherType.SPRING:
			current_season_weather_type = SpringType
		WeatherType.SUMMER:
			current_season_weather_type = SummerType
		WeatherType.AUTUMN:
			current_season_weather_type = AutumnType
		WeatherType.WINTER:
			current_season_weather_type = WinterType

	current_type = random_type(current_season_weather_type)
