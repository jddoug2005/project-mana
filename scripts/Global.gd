# res://scripts/Global.gd
extends Node

# --- Grid Configuration ---
const TILE_SIZE = 32

# --- Economic Data ---
var gold: int = 500
var mana: float = 0.0
var mana_generation_rate: float = 2.5 # Mana per second

# --- Unit Costs (Centralized for easy balancing) ---
const SOLDIER_COST = 50

func _process(delta):
	# The Economic Tick
	mana += mana_generation_rate * delta

# --- Helper: Snapping Logic ---
# This ensures buildings always land perfectly in the center of a 32x32 tile
func snap_to_grid(world_position: Vector2) -> Vector2:
	var snapped_x = (floor(world_position.x / TILE_SIZE) * TILE_SIZE) + (TILE_SIZE / 2)
	var snapped_y = (floor(world_position.y / TILE_SIZE) * TILE_SIZE) + (TILE_SIZE / 2)
	return Vector2(snapped_x, snapped_y)
