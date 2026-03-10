extends CanvasLayer

@onready var label = $Label

func _process(_delta):
	# Access the global singleton to get the current resource values
	var current_mana = int(Global.mana)
	var current_gold = Global.gold
	
	# Update the text displayed on screen
	label.text = "MANA: " + str(current_mana) + " | GOLD: " + str(current_gold)
