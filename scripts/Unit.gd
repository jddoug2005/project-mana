extends CharacterBody2D

# --- States ---
enum State {IDLE, MOVING, CHASING, RETURNING}
var current_state = State.IDLE

# --- Stats ---
var max_health: float = 100.0
var current_health: float = 100.0
var speed: float = 150.0
var damage: float = 10.0
var attack_range: float = 45.0
var detection_range: float = 160.0
var leash_range: float = 300.0 

# --- Logic Variables ---
var current_path: PackedVector2Array = []
var HALF_TILE = Vector2(Global.TILE_SIZE / 2.0, Global.TILE_SIZE / 2.0)
var is_selected = false
var scout_center: Vector2 
var target_enemy: Node2D = null
var is_persistent_chase: bool = false 

# Defensive node fetching
@onready var health_bar = get_node_or_null("HealthBar")
@onready var selection_circle = get_node_or_null("SelectionCircle")
var attack_timer: Timer

func _ready():
	add_to_group("units")
	scout_center = global_position
	
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = 1.0
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health
		health_bar.visible = false # Hide by default

func set_selected(value: bool):
	is_selected = value
	if selection_circle:
		selection_circle.visible = value

func take_damage(amount: float):
	current_health = clamp(current_health - amount, 0, max_health)
	if health_bar:
		health_bar.value = current_health
		health_bar.visible = (current_health < max_health)
	
	if current_health <= 0:
		queue_free()

func _on_attack_timer_timeout():
	if is_instance_valid(target_enemy):
		if global_position.distance_to(target_enemy.global_position) <= attack_range:
			if target_enemy.has_method("take_damage"):
				target_enemy.take_damage(damage)

func find_path(target_pos: Vector2, astar: AStarGrid2D, persistent_target: Node2D = null):
	if persistent_target:
		target_enemy = persistent_target
		is_persistent_chase = true
		current_state = State.CHASING
	else:
		is_persistent_chase = false
		target_enemy = null
		scout_center = target_pos
		current_state = State.MOVING
	
	_calculate_grid_path(target_pos, astar)

func _calculate_grid_path(target_pos: Vector2, astar: AStarGrid2D):
	var start_cell = Vector2i(global_position / Global.TILE_SIZE)
	var end_cell = Vector2i(target_pos / Global.TILE_SIZE)
	if astar.is_in_boundsv(end_cell):
		var raw_path = astar.get_point_path(start_cell, end_cell)
		current_path = PackedVector2Array()
		for p in raw_path:
			current_path.append(p + HALF_TILE)
		if current_path.size() > 0:
			current_path.remove_at(0)

func _physics_process(_delta):
	match current_state:
		State.IDLE:
			check_for_enemies()
			velocity = Vector2.ZERO
		State.MOVING:
			follow_path()
			if current_path.is_empty():
				current_state = State.IDLE
		State.CHASING:
			handle_chase_logic()
		State.RETURNING:
			follow_path()
			if current_path.is_empty():
				current_state = State.IDLE

func check_for_enemies():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if global_position.distance_to(enemy.global_position) <= detection_range:
			target_enemy = enemy
			current_state = State.CHASING
			break

func handle_chase_logic():
	if not is_instance_valid(target_enemy):
		return_to_scout_center()
		return

	var dist_to_enemy = global_position.distance_to(target_enemy.global_position)
	var dist_to_center = global_position.distance_to(scout_center)

	if not is_persistent_chase and dist_to_center > leash_range:
		return_to_scout_center()
		return

	if dist_to_enemy <= attack_range:
		velocity = Vector2.ZERO
		if attack_timer.is_stopped():
			attack_timer.start()
	else:
		attack_timer.stop()
		velocity = global_position.direction_to(target_enemy.global_position) * speed
		move_and_slide()

func return_to_scout_center():
	target_enemy = null
	is_persistent_chase = false
	attack_timer.stop()
	current_state = State.RETURNING
	# Request path to center from World if available
	if get_parent().astar:
		_calculate_grid_path(scout_center, get_parent().astar)

func follow_path():
	if current_path.is_empty(): return
	var target_point = current_path[0]
	velocity = global_position.direction_to(target_point) * speed
	if global_position.distance_to(target_point) < 4:
		current_path.remove_at(0)
	move_and_slide()
