extends Node2D
var save
var save_info
var bodies
var reset = false
var tile_positions
var POSSESS_TARGET
var SAVE_READY = true
func _ready():
	_reset(Autoloads.LAST_LOADED)
func _reset(file):
	reset = true
	Autoloads.RESET = true
	$Player.POSSESS_END = true
	await get_tree().process_frame
	_load(file)
	Autoloads.POSSESS_AMOUNT = 0
	Autoloads.PLAYER_POSSESSING = false
	await get_tree().process_frame
	print($Player.POSSESS_END)
	Autoloads.RESET = false
	$StaticBody2D.call("_set_enemy")
	print(Autoloads.PLAYER_POSSESSING)
	Autoloads.PLAYER_POSSESSING = false
	$Player.POSSESS_END = false
	await get_tree().process_frame
	_enemy_set()
	$Player.POSSESS_START = true

func _load(file):
	Autoloads._load_game(file)
	match Autoloads.location:
		"test_1":
			$Player.position = Vector2i(232, 136)
		"test_2":
			$Player.position = Vector2i(360, -8)
		"test_3":
			$Player.position = Vector2i(1048, -56)
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
func _on_texture_button_pressed() -> void:
	$Player/Camera2D/Control.FILE_OPEN = true
	SAVE_READY = true
func _on_texture_button_3_pressed() -> void:
	if $Player/Camera2D/Control.FILE_OPEN:
		$Player/Camera2D/Control.FILE_OPEN = false
	else:
		get_tree().paused = false
		if Autoloads.PLAYER_POSSESSING:
			$Player/Sprite2D.visible = true
			$Player/PlayerIndicator.visible = true
func _on_texture_button_2_pressed() -> void:
	$Player/Camera2D/Control.FILE_OPEN = true
	SAVE_READY =  false
func _on_texture_button_4_pressed() -> void:
	Autoloads.play_time = Time.get_ticks_msec() - Autoloads.START_TIME + Autoloads.recorded_time
	Autoloads.played_time.hour = int(Autoloads.play_time / 360000)
	Autoloads.played_time.minute = Autoloads.played_time.hour * -60 + int(Autoloads.play_time / 60000)
	print(Autoloads.played_time.hour)
	print(Autoloads.played_time.minute)
	_save_files(1)
func _on_texture_button_5_pressed() -> void:
	Autoloads.play_time = Time.get_ticks_msec() - Autoloads.START_TIME + Autoloads.recorded_time
	Autoloads.played_time.hour = int(Autoloads.play_time / 360000)
	Autoloads.played_time.minute = Autoloads.played_time.hour * -60 + int(Autoloads.play_time / 60000)
	_save_files(2)
func _save_update(file):
		var SAVE_ACCESS_1 = FileAccess.open("user://save_1.save", FileAccess.READ)
		var SAVE_ACCESS_2 = FileAccess.open("user://save_2.save", FileAccess.READ)
		var SAVE_ACCESS_3 = FileAccess.open("user://save_3.save", FileAccess.READ)
		var DATA_1 = SAVE_ACCESS_1.get_var()
		var DATA_2 = SAVE_ACCESS_2.get_var()
		var DATA_3 = SAVE_ACCESS_3.get_var()
		DATA_1.hour = int(DATA_1.play_time / 360000)
		DATA_1.minute = int(DATA_1.play_time / 60000 - DATA_1.hour * 60)
		DATA_2.hour = int(DATA_2.play_time / 360000)
		DATA_2.minute = int(DATA_2.play_time / 60000 - DATA_2.hour * 60)
		DATA_3.hour = int(DATA_3.play_time / 360000)
		DATA_3.minute = int(DATA_3.play_time / 60000 - DATA_3.hour * 60)
		var extra_zero = "0%s"
		var extra_extra_zero = "00%s"
		if DATA_1.minute < 10:
			DATA_1.minute  = extra_zero % [DATA_1.minute]
		if DATA_2.minute < 10:
			DATA_2.minute  = extra_zero % [DATA_2.minute]
		if DATA_3.minute < 10:
			DATA_3.minute  = extra_zero % [DATA_3.minute]
		if DATA_1.hour < 10:
			DATA_1.hour = extra_extra_zero % [DATA_1.hour]
		else:
			if DATA_1.hour < 100:
				DATA_1.hour = extra_zero % [DATA_1.hour]
		if DATA_2.hour < 10:
			DATA_2.hour = extra_extra_zero % [DATA_2.hour]
		else:
			if DATA_2.hour < 100:
				DATA_2.hour = extra_zero % [DATA_2.hour]
		if DATA_3.hour < 10:
			DATA_3.hour = extra_extra_zero % [DATA_3.hour]
		else:
			if DATA_3.hour < 100:
				DATA_3.hour = extra_zero % [DATA_3.hour]
		var time_format = "%s:%s"
		var time_1_display = time_format % [DATA_1.hour, DATA_1.minute]
		var time_2_display = time_format % [DATA_2.hour, DATA_2.minute]
		var time_3_display = time_format % [DATA_3.hour, DATA_3.minute]
		$Player/Camera2D/Control/BoxContainer2/TextureButton4/Label.text = time_1_display
		$Player/Camera2D/Control/BoxContainer2/TextureButton4/Label2.text = DATA_1.place
		$Player/Camera2D/Control/BoxContainer2/TextureButton4/Label3.text = DATA_1.enemy
		$Player/Camera2D/Control/BoxContainer2/TextureButton5/Label.text = time_2_display
		$Player/Camera2D/Control/BoxContainer2/TextureButton5/Label2.text = DATA_2.place
		$Player/Camera2D/Control/BoxContainer2/TextureButton5/Label3.text = DATA_2.enemy
		$Player/Camera2D/Control/BoxContainer2/TextureButton6/Label.text = time_3_display
		$Player/Camera2D/Control/BoxContainer2/TextureButton6/Label2.text = DATA_3.place
		$Player/Camera2D/Control/BoxContainer2/TextureButton6/Label3.text = DATA_3.enemy
func _save_files(file):
	if SAVE_READY:
		$Player.OVERLAPPING_SAVE.call_deferred("_save", Autoloads.POSSESS_ENEMY, file)
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		_save_update(file)
	if not SAVE_READY:
		_reset(file)
func _on_texture_button_6_pressed() -> void:
	Autoloads.play_time = Time.get_ticks_msec() - Autoloads.START_TIME + Autoloads.recorded_time
	Autoloads.played_time.hour = int(Autoloads.play_time / 360000)
	Autoloads.played_time.minute = Autoloads.played_time.hour * -60 + int(Autoloads.play_time / 60000)
	_save_files(3)


func _on_home_return_pressed() -> void:
	pass
