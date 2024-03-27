extends CharacterBody2D
class_name Player

# Signal được phát khi HP của player bị thay đổi
signal updated_hp

# using to check player can farm

var farm_state = null
var current_slot_selected: Slot
var mov_direction: Vector2 = Vector2.ZERO
var FRICTION = 0.15

@export var MAX_SPEED = 100
@export var MAX_HP = 100
@export var ACCELERATION = 40
@export var HP: int = 10

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var state: StateChart = $StateChart
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	PlayerEvents.connect("on_use_item", _on_use_item)
	PlayerEvents.connect("on_select_hotbar_slot", _on_select_hotbar_slot)


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_position = get_global_mouse_position()
			if position.distance_squared_to(mouse_position) >= 40:
				pass
			else:
				var action_type = get_item_property("action_type")
				match action_type:
					"hoe":
						FarmEvents.emit_signal("on_hoe", mouse_position)
					_:
						pass


func get_input():
	mov_direction = Input.get_vector("left", "right", "up", "down")


func _process(_delta):
	get_input()

	if mov_direction != Vector2.ZERO:
		move()

	if velocity <= Vector2.ZERO:
		animated.flip_h = true
	else:
		animated.flip_h = false


# Sử dụng tương tự hàm move
func move_to_target():
	var next_path = agent.get_next_path_position()

	var new_dir: Vector2 = global_position.direction_to(next_path)

	if agent.avoidance_enabled:
		agent.set_velocity(velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(velocity)

	if agent.is_navigation_finished():
		mov_direction = Vector2.ZERO
		return
	mov_direction = new_dir


func change_hp(value: int):
	HP += value
	if HP >= MAX_HP:
		HP = MAX_HP
	updated_hp.emit(HP)


func _on_select_hotbar_slot(slot: Slot):
	current_slot_selected = slot


func eat_food():
	var properties = current_slot_selected.item.properties

	if HP < MAX_HP:
		change_hp(properties.healing)
		current_slot_selected.amount -= 1


# using when click on hotbar
func _on_use_item(slot: Slot):
	if slot and slot.item:
		var action = slot.item
		match action:
			GlobalEvents.product_actions.FOOD:
				eat_food()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	mov_direction = safe_velocity


func _on_movement_state_physics_processing(_delta):
	var target_pos = agent.get_next_path_position()
	if position.distance_to(target_pos) >= 32:
		mov_direction = target_pos - global_position
		move()
	else:
		state.send_event("navigation_finished")


func move():
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * ACCELERATION
	velocity = velocity.limit_length(MAX_SPEED)
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	move_and_slide()


# if current_slot_selected
# kiểm tra current_slot_selected có properties action không
# nếu k có action return -1
# nếu có thì return properties damage
# hoặc return 0
# với giá trị == 0 thì sẽ thực hiện nhừng hàng động k cần tool damage(thu hoạch)
func check_farm_state(key: String) -> int:
	if not current_slot_selected:
		return -1

	var check_is_tool = check_item_is_tool()
	if check_is_tool == -1:
		return -1

	var action_type = get_item_property("action_type")
	if action_type == -1:
		return -1

	match key:
		"chop":
			var damage = get_item_property("damage")
			if action_type == key:
				return damage
			return 0
		"harvest":
			if action_type == key:
				return 0
			return -1
		_:
			return -1


# Trả về -1 nếu k có category = tool.tres
func check_item_is_tool() -> int:
	var item = current_slot_selected.item
	var tool_res = load("res://scenes/inventory/db/categories/tool.tres")
	var check_is_tool = item.categories.check_item.find(tool_res)

	if check_is_tool == -1:
		return -1

	return check_is_tool


# Trả về -1 nếu k có property_name
func get_item_property(property_name: String):
	var property = current_slot_selected.item.properties.get(property_name)

	if not property:
		return -1

	return property


func play_animation(animation_name):
	return
	animated.play(animation_name)


func cancel_farm():
	animated.stop()
