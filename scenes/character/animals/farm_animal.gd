extends CharacterBody2D
class_name FarmAnimal

@export var MAX_SPEED = 10
@export var ACCELERATION = 40
@export var MAX_HP = 100
@export var HP: int = 10

@onready var state: StateChart = $StateChart
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var hp_timer: Timer = $HpTimer
@onready var state_timer: Timer = $StateTimer
@onready var sensor_area: Area2D = $SensorArea
@onready var live_time: int = 64  # Hours

var mov_direction: Vector2 = Vector2.ZERO
var FRICTION = 0.15
var lived_time: int = 720  # Seconds
var time_to_start_spawn_product: int = 32  # Hours


func _ready():
	hp_timer.wait_time = 5
	hp_timer.start()
	state_timer.wait_time = 10

	state.send_event.call_deferred("initialized")
	sensor_area.visible = false
	mov_direction = random_direction()


func random_direction() -> Vector2:
	var random_x = randf_range(-1, 1)
	var random_y = randf_range(-1, 1)

	return Vector2(random_x, random_y)


func _on_travel_state_physics_processing(_delta):
	move()


func _on_idle_state_physics_processing(_delta):
	pass


func move():
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * ACCELERATION
	velocity = velocity.limit_length(MAX_SPEED)
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	move_and_slide()


func _on_idle_state_entered():
	await state_timer.timeout
	state.send_event("random_direction_setted")


func _on_travel_state_entered():
	await state_timer.timeout
	mov_direction = random_direction()
	state.send_event("random_move_ended")


func _on_hp_timer_timeout():
	HP -= 1
	if HP <= 10:
		hp_timer.stop()
		state_timer.stop()

		var node = get_tree().get_first_node_in_group("Trough")
		if node:
			navigation_agent.set_target_position(node.global_position)
			state.send_event("food_marker_setted")
			sensor_area.visible = true


func _on_place_marker_state_physics_processing(_delta):
	var path_position = navigation_agent.get_next_path_position()
	# and move towards it
	velocity = (path_position - global_position).normalized() * MAX_SPEED
	move_and_slide()
	if velocity.length() <= 5:
		state.send_event("navigation_finished")


func _on_eating_state_entered():
	HP = MAX_HP

	state_timer.start()
	await state_timer.timeout

	hp_timer.start()
	state.send_event("finished_eating")
	sensor_area.visible = false


func _on_sensor_area_entered(area: Area2D):
	var node = area
	if area.owner:
		node = area.owner

	if node.is_in_group("Trough"):
		state.send_event("moved_trough")


func check_can_create_product() -> bool:
	if lived_time >= time_to_start_spawn_product * 60 * 60:
		return true
	return false
