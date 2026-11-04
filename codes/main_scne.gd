extends Node2D
var save
var save_info
var bodies
var reset = false
var tile_positions
var POSSESS_TARGET
func _ready():
	if not FileAccess.file_exists("user://saves.save"):
		Autoloads.RESET = true
func _reset():
	$Player.POSSESS_END = true
	reset = true
	await get_tree().process_frame
	$Player.POSSESS_END = true
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
	if Autoloads.POSSESS_TARGET.species and Autoloads.POSSESS_TARGET.species != "none":
		match Autoloads.POSSESS_TARGET.species:
			"TestEnemy1":
				POSSESS_TARGET = preload("res://scenes/enemy1.tscn").instantiate()
			"TestEnemy2":
				POSSESS_TARGET = preload("res://scenes/enemy2.tscn").instantiate()
			"TestEnemy3":
				POSSESS_TARGET = preload("res://scenes/enemy3.tscn").instantiate()
			"TestEnemy4":
				POSSESS_TARGET = preload("res://scenes/enemy4.tscn").instantiate()
			"TestEnemy5":
				POSSESS_TARGET = preload("res://scenes/enemy5.tscn").instantiate()
			"TestEnemy6":
				POSSESS_TARGET = preload("res://scenes/enemy6.tscn").instantiate()
			"TestEnemy7":
				POSSESS_TARGET = preload("res://scenes/enemy7.tscn").instantiate()
		await get_tree().create_timer(0.2).timeout
		add_child.call_deferred(POSSESS_TARGET)
		POSSESS_TARGET.call("_individual_set", Autoloads.POSSESS_TARGET.individual)
		POSSESS_TARGET.call("_possess_start")
