extends Node2D

@onready var tilemap = $TileMapLayer
var astar = AStarGrid2D.new()

func _ready():
	setup_navigation_grid()

func setup_navigation_grid():
	var rect = tilemap.get_used_rect()
	
	astar.region = rect
	astar.cell_size = Vector2(Global.TILE_SIZE, Global.TILE_SIZE)
	# Use DIAGONAL to allow smoother, more natural RTS movement
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.update()

	# Mark walls as solid
	for cell in tilemap.get_used_cells():
		var data = tilemap.get_cell_tile_data(cell)
		# Checks if the tile has any collision shapes defined in Physics Layer 0
		if data and data.get_collision_polygons_count(0) > 0:
			astar.set_point_solid(cell, true)
	
	print("Navigation Map Loaded. Rect: ", rect)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var target_destination = get_global_mouse_position()
			get_tree().call_group("units", "find_path", target_destination, astar)

func update_grid_for_building(pos: Vector2, size: int):
	# Calculate the top-left tile coordinate of the building
	var grid_pos = Vector2i((pos - Vector2(size * Global.TILE_SIZE / 2.0, size * Global.TILE_SIZE / 2.0)) / Global.TILE_SIZE)
	for x in range(size):
		for y in range(size):
			var cell = grid_pos + Vector2i(x, y)
			if astar.is_in_boundsv(cell):
				astar.set_point_solid(cell, true)
