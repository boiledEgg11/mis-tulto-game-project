extends Node2D
var save
var save_info
var bodies
var reset = false
var tile_positions
var POSSESS_TARGET
func _ready():
	_reset()
func _reset():
	Autoloads.RESET = true
	print("hi")
	reset = true
	$Player.POSSESS_END = true
	await get_tree().process_frame
	_load()
	Autoloads.RESET = false
	$StaticBody2D.call("_set_enemy")
	Autoloads.POSSESS_AMOUNT = 0
	Autoloads.PLAYER_POSSESSING = true
	await get_tree().process_frame
	_enemy_set()
func _process(delta: float) -> void:
	if not reset:
		_reset()
func _load():
	Autoloads._load_game()
	match Autoloads.location:
		"test_1":
			$Player.position = Vector2i(232, 136)
		"test_2":
			$Player.position = Vector2i(360, -8)
		_:
			$Player.position = Vector2i(0, 0)
func _enemy_set():
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
		await get_tree().process_frame
		add_child.call_deferred(POSSESS_TARGET)
		POSSESS_TARGET.call("_individual_set", Autoloads.POSSESS_TARGET.individual)
		POSSESS_TARGET.call("_possess_start")
