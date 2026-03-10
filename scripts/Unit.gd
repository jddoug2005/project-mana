extends CharacterBody2D

var unit_stats = {"speed": 150}
var current_path: PackedVector2Array = []
# Offset to move the path to the center of 32x32 tiles
var HALF_TILE = Vector2(Global.TILE_SIZE / 2.0, Global.TILE_SIZE / 2.0)

func _ready():
	add_to_group("units")
	var config = ConfigFile.new()
	var err = config.load("res://data/units/soldier.cfg")
	if err == OK:
		unit_stats["speed"] = config.get_value("Soldier", "speed", 150)

func find_path(target_pos: Vector2, astar: AStarGrid2D):
	var start_cell = Vector2i(global_position / Global.TILE_SIZE)
	var end_cell = Vector2i(target_pos / Global.TILE_SIZE)
	
	if astar.is_in_boundsv(end_cell):
		# Get the raw path (points are at the top-left of tiles)
		var raw_path = astar.get_point_path(start_cell, end_cell)
		
		# Move every point in the path to the center of the tile
		var centered_path = PackedVector2Array()
		for p in raw_path:
			centered_path.append(p + HALF_TILE)
		
		current_path = centered_path
		
		if current_path.size() > 0:
			current_path.remove_at(0)
		
		# Visual Line Update
		if has_node("Line2D"):
			var local_points = PackedVector2Array()
			for p in current_path:
				local_points.append(to_local(p))
			$Line2D.points = local_points

func _physics_process(_delta):
	if current_path.is_empty():
		velocity = Vector2.ZERO
		return

	var target_point = current_path[0]
	var direction = global_position.direction_to(target_point)
	velocity = direction * unit_stats["speed"]
	
	# Check distance to the center-point of the tile
	if global_position.distance_to(target_point) < 4:
		current_path.remove_at(0)
		
	move_and_slide()
