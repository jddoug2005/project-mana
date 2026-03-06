extends CharacterBody2D

# This dictionary will hold the stats once they are loaded
var unit_stats = {}

func load_unit_data(path: String):
	var config = ConfigFile.new()
	var err = config.load(path)
	
	if err == OK:
		# Pull stats from the [stats] section of your .cfg
		unit_stats["name"] = config.get_value("stats", "name", "Unknown Unit")
		unit_stats["hp"] = config.get_value("stats", "hp", 100)
		unit_stats["speed"] = config.get_value("stats", "speed", 200)
		unit_stats["attack"] = config.get_value("stats", "attack_power", 10)
		
		# Apply the placeholder visual
		var sprite_path = config.get_value("visuals", "sprite_path", "res://icon.svg")
		$Sprite2D.texture = load(sprite_path)
		
		print("Successfully loaded: ", unit_stats["name"])
	else:
		print("Error: Could not find the data file at ", path)

func _ready():
	# For now, we manually tell it to load the soldier data you made
	load_unit_data("res://data/units/soldier.cfg")
