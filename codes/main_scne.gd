extends Node2D
var save
var save_info
var bodies
var reset = false
var tile_positions
func _reset():
	reset = true
	await get_tree().process_frame
	Autoloads._load_game()
	_load()
	Autoloads.RESET = false
	await get_tree().process_frame
	$StaticBody2D.call("_set_enemy")
	reset = false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("l"):
		_load()
	if Autoloads.RESET and not reset:
		_reset()
func _load():
	match Autoloads.location:
		"test_1":
			$Player.position = Vector2i(232, 136)
		"test_2":
			$Player.position = Vector2i(360, -8)
		_:
			$Player.position = Vector2i(0, 0)
