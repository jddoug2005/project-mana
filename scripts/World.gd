extends Node2D

@onready var tilemap = $TileMapLayer
var astar = AStarGrid2D.new()

# --- Selection Variables ---
var dragging = false
var selected_units = []
var drag_start = Vector2.ZERO
var select_rect = Rect2()

func _ready():
	setup_navigation_grid()

func setup_navigation_grid():
	# 1. Get the boundaries of your painted map
	var rect = tilemap.get_used_rect()
	
	# 2. Configure the AStar Grid
	astar.region = rect
	astar.cell_size = Vector2(Global.TILE_SIZE, Global.TILE_SIZE)
	# Allows diagonal movement for a more natural RTS feel
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.update()

	# 3. Scan the map and mark tiles with physics as "Solid" walls
	for cell in tilemap.get_used_cells():
		var data = tilemap.get_cell_tile_data(cell)
		# Checks Physics Layer 0 for collision shapes
		if data and data.get_collision_polygons_count(0) > 0:
			astar.set_point_solid(cell, true)
	
	print("Navigation Grid Initialized. Size: ", rect.size)

func _input(event):
	# --- Right Click: Move or Attack ---
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		var target_pos = get_global_mouse_position()
		var enemy_target = get_enemy_under_mouse(target_pos)
		
		for unit in selected_units:
			if is_instance_valid(unit):
				# If an enemy is clicked, units will enter "Persistent Chase"
				# Otherwise, they move to the ground and set a new "Scout Center"
				unit.find_path(target_pos, astar, enemy_target)

	# --- Left Click: Selection Box ---
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_start = get_global_mouse_position()
			# Clear selection unless holding Shift
			if not Input.is_key_pressed(KEY_SHIFT):
				deselect_all()
		else:
			dragging = false
			queue_redraw() # Hide the visual box
			select_units_in_rect()

	if event is InputEventMouseMotion and dragging:
		queue_redraw() # Update the visual box as you move the mouse

func get_enemy_under_mouse(pos: Vector2):
	# Helper to detect if the player right-clicked an enemy
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		# 24 pixel buffer makes it easier to click small units
		if enemy.global_position.distance_to(pos) < 24:
			return enemy
	return null

func _draw():
	# Visualizes the green RTS selection box
	if dragging:
		var drag_end = get_global_mouse_position()
		select_rect = Rect2(drag_start, drag_end - drag_start).abs()
		draw_rect(select_rect, Color(0, 1, 0, 0.1), true) # Transparent Fill
		draw_rect(select_rect, Color(0, 1, 0, 0.5), false, 2.0) # Solid Border

func select_units_in_rect():
	# Finds all units within the drawn box
	var all_units = get_tree().get_nodes_in_group("units")
	for unit in all_units:
		if select_rect.has_point(unit.global_position):
			unit.set_selected(true)
			if not selected_units.has(unit):
				selected_units.append(unit)

func deselect_all():
	for unit in selected_units:
		if is_instance_valid(unit):
			unit.set_selected(false)
	selected_units.clear()

# --- Grid Management ---
func update_grid_for_building(pos: Vector2, size: int):
	# Marks the ground under a new building as solid so units path around it
	var grid_pos = Vector2i((pos - Vector2(size * Global.TILE_SIZE / 2.0, size * Global.TILE_SIZE / 2.0)) / Global.TILE_SIZE)
	for x in range(size):
		for y in range(size):
			var cell = grid_pos + Vector2i(x, y)
			if astar.is_in_boundsv(cell):
				astar.set_point_solid(cell, true)
