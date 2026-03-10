extends Node2D

@onready var tilemap = $TileMapLayer
var astar = AStarGrid2D.new()

# Selection Variables
var dragging = false
var selected_units = []
var drag_start = Vector2.ZERO
var select_rect = Rect2()

func _ready():
	setup_navigation_grid()

func setup_navigation_grid():
	var rect = tilemap.get_used_rect()
	astar.region = rect
	astar.cell_size = Vector2(Global.TILE_SIZE, Global.TILE_SIZE)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	astar.update()

	for cell in tilemap.get_used_cells():
		var data = tilemap.get_cell_tile_data(cell)
		if data and data.get_collision_polygons_count(0) > 0:
			astar.set_point_solid(cell, true)

func _input(event):
	# --- RIGHT CLICK: Move or Attack ---
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		var target_pos = get_global_mouse_position()
		var enemy_target = get_enemy_under_mouse(target_pos)
		
		for unit in selected_units:
			if is_instance_valid(unit):
				unit.find_path(target_pos, astar, enemy_target)

	# --- LEFT CLICK: Selection Box ---
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_start = get_global_mouse_position()
			if not Input.is_key_pressed(KEY_SHIFT):
				deselect_all()
		else:
			dragging = false
			queue_redraw()
			select_units_in_rect()

	if event is InputEventMouseMotion and dragging:
		queue_redraw()

func get_enemy_under_mouse(pos: Vector2):
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		# Check if click is within 24 pixels of the enemy center
		if enemy.global_position.distance_to(pos) < 24:
			return enemy
	return null

func _draw():
	if dragging:
		var drag_end = get_global_mouse_position()
		select_rect = Rect2(drag_start, drag_end - drag_start).abs()
		draw_rect(select_rect, Color(0, 1, 0, 0.1), true)
		draw_rect(select_rect, Color(0, 1, 0, 0.5), false, 2.0)

func select_units_in_rect():
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

func update_grid_for_building(pos: Vector2, size: int):
	var grid_pos = Vector2i((pos - Vector2(size * Global.TILE_SIZE / 2.0, size * Global.TILE_SIZE / 2.0)) / Global.TILE_SIZE)
	for x in range(size):
		for y in range(size):
			var cell = grid_pos + Vector2i(x, y)
			if astar.is_in_boundsv(cell):
				astar.set_point_solid(cell, true)
