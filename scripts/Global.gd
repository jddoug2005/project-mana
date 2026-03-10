# res://scripts/Global.gd
extends Node

const TILE_SIZE = 32

# --- Economic Data ---
var gold: int = 500
var mana: float = 0.0
var mana_generation_rate: float = 2.5 

const SOLDIER_COST = 50

func _process(delta):
	mana += mana_generation_rate * delta

# --- Enhanced Snapping Logic ---
# size_in_tiles: 1 for a 32x32 building, 2 for a 64x64 building
func snap_to_grid(world_position: Vector2, size_in_tiles: int = 1) -> Vector2:
	var offset = (size_in_tiles * TILE_SIZE) / 2.0
	
	var snapped_x = (floor(world_position.x / TILE_SIZE) * TILE_SIZE) + offset
	var snapped_y = (floor(world_position.y / TILE_SIZE) * TILE_SIZE) + offset
	
	return Vector2(snapped_x, snapped_y)
