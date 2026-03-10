# res://scripts/Global.gd
extends Node

const TILE_SIZE = 32 # Matches your TileMapLayer

var gold: int = 500
var mana: float = 0.0
var mana_generation_rate: float = 2.5 

func _process(delta):
	mana += mana_generation_rate * delta

func snap_to_grid(world_position: Vector2) -> Vector2:
	# Centers the target on the nearest 32x32 tile
	var snapped_x = floor(world_position.x / TILE_SIZE) * TILE_SIZE + (TILE_SIZE / 2)
	var snapped_y = floor(world_position.y / TILE_SIZE) * TILE_SIZE + (TILE_SIZE / 2)
	return Vector2(snapped_x, snapped_y)
