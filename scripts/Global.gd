extends Node

# Player Resources
var gold: int = 500
var mana: float = 0.0

# Economic Balance
var mana_generation_rate: float = 2.5 # Mana per second

func _process(delta):
	# The "Economic Tick" - generating resources over time
	mana += mana_generation_rate * delta
