# res://scripts/World.gd
extends Node2D

func _input(event):
	# 1. Listen for Right Click (Standard RTS "Move" command)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			
			# 2. Get the specific point in the game world that was clicked
			var target_destination = get_global_mouse_position()
			
			# 3. Broadcast the command to all units currently in the "units" group
			# This is the "Macromanagement" approach—commanding the swarm at once
			get_tree().call_group("units", "move_to", target_destination)
			
			# Optional: Visual feedback (print to console for now)
			print("Commanding units to move to: ", target_destination)
