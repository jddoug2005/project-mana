# Project Mana

A medieval fantasy RTS (Real-Time Strategy) game built with the Godot Engine.

## Project Vision
Project Mana aims to deliver an industrial-scale warfare experience. Units are small and numerous, designed to move in swarms and "squeak through" tight gaps, while buildings are large, grid-aligned structures that define the battlefield's geography.

## Current Progress (Phase 4: Structures & Environment)

We have successfully established the foundational "Game Loop" and environmental interactions:

### 1. Grid & Navigation System
* **32x32 Tile Standard:** Established a consistent tile size for all environmental assets and building placements.
* **AStarGrid2D Pathfinding:** Implemented intelligent navigation. Units now calculate the "best route" to a target, automatically avoiding walls and obstacles.
* **Center-Tile Alignment:** Navigation waypoints are automatically offset to tile centers, ensuring units walk down the middle of paths rather than hugging edges.

### 2. Economy & Production
* **Mana Generation:** A global economic "tick" system generates 2.5 Mana per second.
* **Grid-Locked Buildings:** Buildings (Barracks) use a ghost-placement system that snaps to a 64x64 (2x2 tile) grid.
* **Unit Training:** Buildings can consume Mana to instantiate new Soldier units at designated spawn points.

### 3. Controls & Interaction
* **Smooth RTS Camera:** Added a Camera2D with WASD movement and mouse-wheel zoom functionality.
* **Swarm Commands:** Right-click broadcasting allows the player to command all active units to a specific location simultaneously.
* **Path Visualization:** Units now draw a `Line2D` representing their intended path for better player feedback and debugging.

## Technical Architecture
* **Global.gd:** Singleton managing economic state and grid-snapping math.
* **World.gd:** Main controller managing the Navigation Map and player input.
* **Unit.gd:** CharacterBody2D logic handling AStar path following and movement physics.
* **Building.gd:** StaticBody2D logic handling placement states and unit production.

## Next Steps
* **Selection Logic:** Implement a click-and-drag selection box to control specific unit groups.
* **Combat Fundamentals:** Add health components and basic "Attack-Move" behavior.
* **Fog of War:** Implement a visibility system to hide unexplored areas of the map.
