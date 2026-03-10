# res://scripts/World.gd
extends Node2D

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			# Get EXACT pixel coordinates for smooth, organic movement
			var target_destination = get_global_mouse_position()
			
			# Command all units to move to this point
			get_tree().call_group("units", "move_to", target_destination)
