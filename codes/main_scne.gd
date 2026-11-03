extends Node2D
var save
var save_info
var bodies
var tile_positions
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("l"):
		_load()
func _load():
	match Autoloads.location:
		"test_1":
			$Player.position = Vector2i(232, 136)
		"test_2":
			$Player.position = Vector2i(360, -8)
		_:
			$Player.position = Vector2i(0, 0)
