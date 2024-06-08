extends StaticBody2D
class_name Nest

@onready var amount_animal: int = 0
@onready var value: int = 0

@onready var sprite: Sprite2D = $Sprite2D

@export var max_value: int = 30


func create_obstacle():
	var new_obstacle_rid: RID = NavigationServer2D.obstacle_create()
	var default_2d_map_rid: RID = get_world_2d().get_navigation_map()

	NavigationServer2D.obstacle_set_map(new_obstacle_rid, default_2d_map_rid)
	NavigationServer2D.obstacle_set_position(new_obstacle_rid, global_position)
	NavigationServer2D.obstacle_set_radius(new_obstacle_rid, 5.0)

	# Enable the obstacle.
	NavigationServer2D.obstacle_set_avoidance_enabled(new_obstacle_rid, true)


func _ready():
	create_obstacle()


func add_product(amount: int):
	if value >= max_value:
		return
	value += amount
	run_animation()


func run_animation():
	if value == 0:
		sprite.frame = 0
	elif value <= 10:
		sprite.frame = 1
	else:
		sprite.frame = 2
