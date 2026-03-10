extends CharacterBody2D

# Enemies use a simpler AI: they just hunt anything in the "units" group
var max_health: float = 80.0
var current_health: float = 80.0
var speed: float = 120.0
var damage: float = 8.0
var attack_range: float = 45.0
var detection_range: float = 200.0

var target_player_unit: Node2D = null

@onready var health_bar = get_node_or_null("HealthBar")
var attack_timer: Timer

func _ready():
	add_to_group("enemies")
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = 1.2
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health
		health_bar.visible = false

func take_damage(amount: float):
	current_health -= amount
	if health_bar:
		health_bar.value = current_health
		health_bar.visible = true
	if current_health <= 0:
		queue_free()

func _on_attack_timer_timeout():
	if is_instance_valid(target_player_unit):
		if global_position.distance_to(target_player_unit.global_position) <= attack_range:
			target_player_unit.take_damage(damage)

func _physics_process(_delta):
	if not is_instance_valid(target_player_unit):
		find_new_target()
		velocity = Vector2.ZERO
		return

	var dist = global_position.distance_to(target_player_unit.global_position)
	
	if dist <= attack_range:
		velocity = Vector2.ZERO
		if attack_timer.is_stopped():
			attack_timer.start()
	elif dist <= detection_range:
		attack_timer.stop()
		velocity = global_position.direction_to(target_player_unit.global_position) * speed
		move_and_slide()
	else:
		target_player_unit = null

func find_new_target():
	var players = get_tree().get_nodes_in_group("units")
	for p in players:
		if global_position.distance_to(p.global_position) <= detection_range:
			target_player_unit = p
			break
