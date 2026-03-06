extends CharacterBody2D

var unit_stats = {}
var target_position: Vector2 = Vector2.ZERO
var is_moving: bool = false

func _ready():
	# Essential for detecting clicks on the unit later
	input_pickable = true
	# Start at current position so units don't rush to (0,0) at spawn
	target_position = global_position 
	load_unit_data("res://data/units/soldier.cfg")

func load_unit_data(path: String):
	var config = ConfigFile.new()
	var err = config.load(path)
	if err == OK:
		unit_stats["name"] = config.get_value("stats", "name", "Unit")
		# Pull speed from your .cfg file
		unit_stats["speed"] = config.get_value("stats", "speed", 150)
		$Sprite2D.texture = load(config.get_value("visuals", "sprite_path", "res://icon.svg"))

func _physics_process(_delta):
	if is_moving:
		var direction = global_position.direction_to(target_position)
		var distance = global_position.distance_to(target_position)
		
		# Move until we are within 5 pixels of the target
		if distance > 5:
			velocity = direction * unit_stats["speed"]
			move_and_slide()
		else:
			is_moving = false
			velocity = Vector2.ZERO

# This is the "Command" function the World script will call
func move_to(goal: Vector2):
	target_position = goal
	is_moving = true
