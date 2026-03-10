extends StaticBody2D

@onready var unit_scene = preload("res://scenes/Unit.tscn")
@onready var spawn_point = $SpawnPoint

var is_preview_mode: bool = true

func _ready():
	if is_preview_mode:
		modulate.a = 0.5
		$CollisionShape2D.disabled = true

func _process(_delta):
	if is_preview_mode:
		global_position = Global.snap_to_grid(get_global_mouse_position())

func _input(event):
	if is_preview_mode and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			place_building()

func place_building():
	is_preview_mode = false
	modulate.a = 1.0 
	$CollisionShape2D.disabled = false 

func _input_event(_viewport, event, _shape_idx):
	if not is_preview_mode and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			train_unit()

func train_unit():
	if Global.mana >= Global.SOLDIER_COST:
		Global.mana -= Global.SOLDIER_COST
		var new_unit = unit_scene.instantiate()
		new_unit.global_position = spawn_point.global_position
		get_parent().add_child(new_unit)
