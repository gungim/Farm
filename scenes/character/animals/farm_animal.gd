extends CharacterBody2D
class_name FarmAnimal

@export var MAX_SPEED = 10
@export var ACCELERATION = 40
@export var MAX_HP = 100
@export var HP: int = 10
@export var time_to_start_spawn_product: int  # Hours
@export var live_time: int = 720  # Hours
@export var state_wait_time: float = 10.

@onready var state: StateChart = $StateChart
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var hp_timer: Timer = $HpTimer
@onready var sensor_area: Area2D = $SensorArea
@onready var hp_label: ProgressBar = $HPLabel
@onready var live_timer: Timer = $LiveTimer
@onready var spawn_product_component: SpawnProductComponent = $SpawnProductComponent

var product_timer: Timer
var mov_direction: Vector2 = Vector2.ZERO
var FRICTION = 0.15
var lived_time: int = 649000  # Seconds

var target_marker_group_name


func _ready():
	if not spawn_product_component.started:
		product_timer = Timer.new()
		product_timer.wait_time = 10
		add_child(product_timer)
		product_timer.start()
		product_timer.timeout.connect(_product_timer_timeout)

	hp_timer.wait_time = 20
	hp_timer.start()

	live_timer.wait_time = 5
	live_timer.start()

	state.send_event.call_deferred("initialized")
	sensor_area.visible = false
	mov_direction = random_direction()

	hp_label.value = HP
	hp_label.max_value = MAX_HP

	if not time_to_start_spawn_product:
		time_to_start_spawn_product = int(live_time / 4.)

	navigation_agent.navigation_finished.connect(_on_navigation_agent_2d_finished)


func random_direction() -> Vector2:
	var random_x = randf_range(-1, 1)
	var random_y = randf_range(-1, 1)

	return Vector2(random_x, random_y)


func _on_travel_state_physics_processing(_delta):
	var path_position: Vector2 = navigation_agent.get_next_path_position()
	# and move towards it
	mov_direction = path_position - position
	move()


func _on_idle_state_physics_processing(_delta):
	pass


func _on_place_marker_state_physics_processing(_delta):
	var path_position: Vector2 = navigation_agent.get_next_path_position()
	# and move towards it
	mov_direction = path_position - position
	move()
	if velocity.length() <= 5:
		state.send_event("navigation_finished")


func move():
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * ACCELERATION
	velocity = velocity.limit_length(MAX_SPEED)
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	move_and_slide()


func _on_idle_state_entered():
	navigation_agent.navigation_finished.emit()

	await get_tree().create_timer(state_wait_time).timeout
	if HP <= 10:
		hp_timer.stop()
		set_food_marker()
	else:
		state.send_event("random_direction_setted")


func _on_travel_state_entered():
	await get_tree().create_timer(state_wait_time).timeout

	if HP <= 10:
		hp_timer.stop()
		set_food_marker()
	else:
		state.send_event("random_move_ended")


func _on_eating_state_entered():
	navigation_agent.navigation_finished.emit()
	HP = MAX_HP

	await get_tree().create_timer(state_wait_time).timeout

	hp_timer.start()
	state.send_event("finished_eating")


func _on_sensor_area_entered(area: Area2D):
	var node = area
	if area.owner:
		node = area.owner

	if target_marker_group_name:
		var groups: Array[StringName] = node.get_groups()
		if groups.bsearch(target_marker_group_name) >= 0:
			state.send_event(target_marker_group_name.to_lower() + "_detected")

		sensor_area.visible = false
		target_marker_group_name = null


func _on_place_marker_state_entered():
	pass


func set_food_marker():
	var nodes = get_tree().get_nodes_in_group("Trough")
	var food_positon = find_nearest_node(nodes)

	if food_positon != Vector2.ZERO:
		navigation_agent.set_target_position(food_positon)
		sensor_area.visible = true
		target_marker_group_name = "Trough"
		state.send_event("food_marker_setted")
	else:
		print_debug("Cannot find trough")


func find_nearest_node(nodes: Array[Node]) -> Vector2:
	if nodes.size() <= 0:
		return Vector2.ZERO

	var nearest_node: Node = nodes[0]
	var nearest_node_postion: Vector2 = nearest_node.global_position
	var nearest_node_distance: float = global_position.distance_to(nearest_node_postion)
	nodes.remove_at(0)

	for index in nodes.size():
		var node: Node = nodes[index]
		var distance: float = global_position.distance_to(node.global_position)
		if distance < nearest_node_distance:
			nearest_node = node
			nearest_node_postion = nearest_node.global_position
			nearest_node_distance = distance

	if nearest_node:
		return nearest_node_postion

	return Vector2.ZERO


func _on_hp_timer_timeout():
	HP -= 1
	hp_label.value = HP


func check_can_create_product() -> bool:
	if lived_time >= time_to_start_spawn_product * 60 * 60:
		return true
	return false


func _start_create_product():
	pass


func _on_live_timer_timeout():
	lived_time += 5


func _product_timer_timeout():
	if check_can_create_product():
		_start_create_product()
		remove_child(product_timer)


func _on_navigation_agent_2d_finished():
	navigation_agent.set_target_position(Vector2.ZERO)


# called if Light calll lights func
func sleep(value: bool):
	if value:
		var nodes = get_tree().get_nodes_in_group("Stall")
		var stall_position = find_nearest_node(nodes)
		if stall_position != Vector2.ZERO:
			sensor_area.visible = true
			navigation_agent.set_target_position(stall_position)
			target_marker_group_name = "Stall"
			state.send_event("stall_marker_setted")
	else:
		state.send_event("wake_up")


func _on_sleep_state_exited():
	product_timer.start()
	live_timer.start()
	hp_timer.start()


func _on_sleep_state_entered():
	product_timer.stop()
	live_timer.stop()
	hp_timer.stop()
