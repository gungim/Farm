extends StaticBody2D
class_name Nest

@onready var amount_animal: int = 0
@onready var product: int = 0

@export var max_value: int = 30


func create_obstacle():
	var new_obstacle_rid: RID = NavigationServer2D.obstacle_create()
	var default_2d_map_rid: RID = get_world_2d().get_navigation_map()

	NavigationServer2D.obstacle_set_map(new_obstacle_rid, default_2d_map_rid)
	NavigationServer2D.obstacle_set_position(new_obstacle_rid, global_position)

	# Use obstacle dynamic by increasing radius above zero.
	NavigationServer2D.obstacle_set_radius(new_obstacle_rid, 5.0)

	# Enable the obstacle.
	NavigationServer2D.obstacle_set_avoidance_enabled(new_obstacle_rid, true)


func _ready():
	create_obstacle()


func add_product(amount: int):
	if product >= max_value:
		return
	product += amount
