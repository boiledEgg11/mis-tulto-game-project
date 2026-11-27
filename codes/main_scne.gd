extends Node2D
var save
var save_info
var bodies
var reset = false
var tile_positions
var POSSESS_ENEMY: Node2D
var SAVE_READY = true
var dash_recover_value: int
var health_value: int
@onready var load_file: int
@export var Player: Node2D
@export var player_shape: Node2D
@onready var designated_position_player:Vector2
@onready var stage: int = 0
var count_format = "x %s"
func _ready():
	_reset(Autoloads.LAST_LOADED)
func _force_erase():
	$ObjectPlacement.call_deferred("_force_erase")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("5"):
		_force_erase()
func _remove_previous_enemy(file):
	if is_instance_valid(POSSESS_ENEMY):
		POSSESS_ENEMY.queue_free()
	call_deferred("_reset_previous", file)
func _reset_previous(file):
	_variable_set()
	reset = true
	Autoloads.RESET = true
	_enemy_set()
func _load_data(file):
	Autoloads.RESET = false
	_load(file)
func _enemy_read(file):
	$ObjectPlacement.call_deferred("_read_data", false, null)
	_force_erase()
	player_shape.call_deferred("set_disabled", true)
	call_deferred("_load_data", file)
func _erase_finish():
	$ObjectPlacement.call_deferred("_read_data", false, null)
	call_deferred("_variable_set")
	call_deferred("_load", load_file)
	call_deferred("_enemy_set")
func _reset(file):
	player_shape.call_deferred("set_disabled", true)
	Player.INVINCIBLE = true
	Player.POSSESS_END = false
	load_file = file
	_force_erase()
func _variable_set():
	for i in Autoloads.tile_move.size():
		Autoloads.tile_move[i] = 0
	Player.POSSESS_START = true
	Player.velocity = Vector2(0, 0)
	Player.DASH_LOCK = false
	Player.ABILITY_LOCK = false
	$Camera2D/BoxContainer/DashRecover.value = 30
	$Camera2D/BoxContainer/PlayerHealth.value = 10
func _erase_enemies():
	$ObjectPlacement._erase_enemy()
func _add_enemies(level):
	print("adding enemies...")
	$ObjectPlacement._read_data(true, level)
func _load(file):
	Autoloads._load_game(file)
	match Autoloads.location:
		"test_2":
			Player._change_map("test_level_map_1", -1)
			Player.position = Vector2i(360, -8)
			designated_position_player = Vector2(360, -8)
		"test_3":
			Player._change_map("test_level_map_1", -1)
			Player.position = Vector2i(1048, -56)
			designated_position_player = Vector2(1048, -56)
		"test_4":
			Player._change_map("test_level_map_2", -1)
			Player.position = Vector2i(-24, 24)
			designated_position_player = Vector2(-24, 24)
		"test_5":
			Player._change_map("test_level_map_2", -1)
			Player.position = Vector2i(-1050, 24)
			designated_position_player = Vector2(-1050, 24)
		"test_6":
			Player._change_map("test_level_map_3", -1)
			Player.position = Vector2(-8, 24)
			designated_position_player = Vector2(-8, 24)
		"test_7":
			Player._change_map("test_level_map_4", -1)
			Player.position = Vector2(0, -24)
			designated_position_player = Vector2(0, -24)
		"test_8":
			Player._change_map("test_level_map_4", -1)
			Player.position = Vector2(-864, -40)
			designated_position_player = Vector2(-864, -40)
		"test_9":
			Player._change_map("test_level_map_5", -1)
			Player.position = Vector2(24, 8)
			designated_position_player = Vector2(24, 8)
		_:
			Player._change_map("test_level_map_1", -1)
			Player.position = Vector2i(0, 0)
			designated_position_player = Vector2(0, 0)
	Player._raid_end()
	$ObjectPlacement.raid = false
	while Player.global_position != designated_position_player:
		pass
	await get_tree().process_frame
	player_shape.call_deferred("set_disabled", false)
func _enemy_set():
	if Autoloads.ENEMY_POSSESS.species and Autoloads.ENEMY_POSSESS.species != "Tulto":
		match Autoloads.ENEMY_POSSESS.species:
			"Slimy":
				POSSESS_ENEMY = preload("res://scenes/enemy/enemy1.tscn").instantiate()
			"Bouncer":
				POSSESS_ENEMY = preload("res://scenes/enemy/enemy2.tscn").instantiate()
			"Pyrofighto":
				POSSESS_ENEMY = preload("res://scenes/enemy/enemy3.tscn").instantiate()
			"Dropper":
				POSSESS_ENEMY = preload("res://scenes/enemy/enemy4.tscn").instantiate()
			"Spinner":
				POSSESS_ENEMY = preload("res://scenes/enemy/enemy5.tscn").instantiate()
			"WhistleDasher":
				POSSESS_ENEMY = preload("res://scenes/enemy/enemy6.tscn").instantiate()
			"Crystaline":
				POSSESS_ENEMY = preload("res://scenes/enemy/enemy7.tscn").instantiate()
			"BladeShooter":
				POSSESS_ENEMY = preload("res://scenes/enemy/enemy8.tscn").instantiate()
			"BigSlimy":
				POSSESS_ENEMY = preload("res://scenes/enemy/enemy9.tscn").instantiate()
		add_child.call_deferred(POSSESS_ENEMY)
		if Autoloads.ENEMY_POSSESS.species != null and not Autoloads.ENEMY_POSSESS.species == "none":
			Autoloads.player.call_deferred("_possess_reset")
			POSSESS_ENEMY.call("_individual_set", Autoloads.ENEMY_POSSESS.individual)
			POSSESS_ENEMY.call("_possess_start")
			$ObjectPlacement.call_deferred("_possess_enemy_set", POSSESS_ENEMY)
func _set_data():
	$ObjectPlacement._read_data(false, -1)
func _on_texture_button_pressed() -> void:
	$Camera2D/Control.FILE_OPEN = true
	SAVE_READY = true
func _on_texture_button_3_pressed() -> void:
	if $Camera2D/Control.FILE_OPEN:
		$Camera2D/Control.FILE_OPEN = false
	else:
		get_tree().paused = false
		Autoloads.SAVE_SCREEN = false
func _on_texture_button_2_pressed() -> void:
	$Camera2D/Control.FILE_OPEN = true
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
		await get_tree().process_frame
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
		var treasure_amount_1 = 0
		for value in DATA_1.treasure:
			if value:
				treasure_amount_1 += 1
		var treasure_amount_2 = 0
		for value in DATA_2.treasure:
			if value:
				treasure_amount_2 += 1
		var treasure_amount_3 = 0
		for value in DATA_3.treasure:
			if value:
				treasure_amount_3 += 1
		var time_format = "%s:%s"
		var time_1_display = time_format % [DATA_1.hour, DATA_1.minute]
		var time_2_display = time_format % [DATA_2.hour, DATA_2.minute]
		var time_3_display = time_format % [DATA_3.hour, DATA_3.minute]
		$Camera2D/Control/BoxContainer2/TextureButton4/TextureRect/Label4.text = count_format % treasure_amount_1
		$Camera2D/Control/BoxContainer2/TextureButton5/TextureRect/Label4.text = count_format % treasure_amount_2
		$Camera2D/Control/BoxContainer2/TextureButton6/TextureRect/Label4.text = count_format % treasure_amount_3
		$Camera2D/Control/BoxContainer2/TextureButton4/Label.text = time_1_display
		$Camera2D/Control/BoxContainer2/TextureButton4/Label2.text = DATA_1.place
		$Camera2D/Control/BoxContainer2/TextureButton4/Label3.text = DATA_1.enemy
		$Camera2D/Control/BoxContainer2/TextureButton5/Label.text = time_2_display
		$Camera2D/Control/BoxContainer2/TextureButton5/Label2.text = DATA_2.place
		$Camera2D/Control/BoxContainer2/TextureButton5/Label3.text = DATA_2.enemy
		$Camera2D/Control/BoxContainer2/TextureButton6/Label.text = time_3_display
		$Camera2D/Control/BoxContainer2/TextureButton6/Label2.text = DATA_3.place
		$Camera2D/Control/BoxContainer2/TextureButton6/Label3.text = DATA_3.enemy
func _save_files(file):
	if SAVE_READY:
		print("saved!")
		Player.OVERLAPPING_SAVE.call_deferred("_save", Player.stats.species, file, Player)
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
func _open_text(number, pause):
	$Camera2D/TextBox._text_open(number, pause)
func _camera_position(x_value, y_value, global: bool):
	if global:
		if y_value < 100 and y_value > -268:
			$Camera2D.global_position = Vector2(x_value, y_value)
		else:
			$Camera2D.global_position = Vector2(x_value, $Camera2D.global_position.y)
	if not global:
		if y_value < 100 and y_value > -268:
			$Camera2D.position = Vector2(x_value, y_value)
		else:
			$Camera2D.global_position = Vector2(x_value, $Camera2D.global_position.y)
func _player_health(value, setting):
	if setting:
		$Camera2D/BoxContainer/PlayerHealth.value = value
	else:
		$Camera2D/BoxContainer/PlayerHealth.value += value
func _dash_recover(value, setting):
	if setting:
		$Camera2D/BoxContainer/DashRecover.value = value
	else:
		$Camera2D/BoxContainer/DashRecover.value += value
func _ability_label(label):
	$Camera2D/BoxContainer/DashRecover/Label.text = label
func _get_dash_recover_value():
	return $Camera2D/BoxContainer/DashRecover.value
func _get_player_health():
	return $Camera2D/BoxContainer/PlayerHealth.value
func _sprite_change(object, texture):
	match object:
		"Camera2D/BoxContainer":
			match texture:
				"visible":
					$Camera2D/Control/BoxContainer.visible = true
		"PlayerHealth":
			match texture:
				"low_health":
					$Camera2D/BoxContainer/PlayerHealth.texture_progress = load("res://assets/sprites/health_bar_low.png")
				"high_health":
					$Camera2D/BoxContainer/PlayerHealth.texture_progress = load("res://assets/sprites/health_bar_high.png")
		"DashRecover":
			match texture:
				"max_dash":
					$Camera2D/BoxContainer/DashRecover.texture_progress = load("res://assets/sprites/dash_bar_max.png")
				"charge_dash":
					$Camera2D/BoxContainer/DashRecover.texture_progress = load("res://assets/sprites/dash_bar_charge_charging.png")
				"normal":
					$Camera2D/BoxContainer/DashRecover.texture_progress = load("res://assets/sprites/dash_bar_high.png")
func _raid(map, area):
	$Camera2D.position_smoothing_enabled = true
	match map:
		"test_map_4":
			print("attack!")
			_camera_position(-1064, -87, true)
			await get_tree().create_timer(0.5).timeout
			$ObjectPlacement._set_enemy("raid_1")
			$ObjectPlacement._raid_area(area)
		"test_map_5":
			print("attack!")
			_camera_position(312, -28, true)
			await get_tree().create_timer(0.5).timeout
			$ObjectPlacement._set_enemy("raid_2")
			$ObjectPlacement._raid_area(area)
func _raid_end():
	$Camera2D.position_smoothing_enabled = false
