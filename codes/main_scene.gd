extends Node2D
var MAIN
var DATA: Array = [
	0,
	0,
	0
	]
var OPENED = false
var MODE = "new"
var START = false
var STARTED = false
var DATA_EMPTY
var OPEN_FILE = 1
var CHARGE = 0
var count_format = "x %s"
var file_new: Dictionary = {
	"file_1": false,
	"file_2": false,
	"file_3": false
}
var SAVE_DEFAULT: Dictionary = {
	"place": "none",
	"enemy": "Tulto",
	"enemy_id": 0,
	"play_time": 0,
	"treasure": [false, false, false, false, false],
	"progression_stage": {
		"Introduction": false,
		"map_1_box": false,
		"raid_1": false,
		"raid_2": false,
		"raid_3": false
	}
}
func _ready() -> void:
	var FILE_EMPTY = FileAccess.open("user://save_empty.save", FileAccess.WRITE)
	FILE_EMPTY.store_var(SAVE_DEFAULT.duplicate())
	FILE_EMPTY.close()
	if not FileAccess.file_exists("user://save_1.save"):
		var SAVE_1 = FileAccess.open("user://save_1.save", FileAccess.WRITE)
		SAVE_1.store_var(SAVE_DEFAULT.duplicate())
		SAVE_1.close()
	if not FileAccess.file_exists("user://save_2.save"):
		var SAVE_2 = FileAccess.open("user://save_2.save", FileAccess.WRITE)
		SAVE_2.store_var(SAVE_DEFAULT.duplicate())
		SAVE_2.close()
	if not FileAccess.file_exists("user://save_3.save"):
		var SAVE_3 = FileAccess.open("user://save_3.save", FileAccess.WRITE)
		SAVE_3.store_var(SAVE_DEFAULT.duplicate())
		SAVE_3.close()
	var EMPTY_FILE = FileAccess.open("user://save_empty.save", FileAccess.WRITE)
	EMPTY_FILE.store_var(SAVE_DEFAULT.duplicate())
	EMPTY_FILE.close()
	var SAVE_ACCESS_EMPTY = FileAccess.open("user://save_empty.save", FileAccess.READ)
	var SAVE_ACCESS_1 = FileAccess.open("user://save_1.save", FileAccess.READ)
	var SAVE_ACCESS_2 = FileAccess.open("user://save_2.save", FileAccess.READ)
	var SAVE_ACCESS_3 = FileAccess.open("user://save_3.save", FileAccess.READ)
	DATA[0] = SAVE_ACCESS_1.get_var()
	DATA[1] = SAVE_ACCESS_2.get_var()
	DATA[2] = SAVE_ACCESS_3.get_var()
	DATA_EMPTY = SAVE_ACCESS_EMPTY.get_var()
	for l in range(0,3):
		for i in SAVE_DEFAULT:
			if not DATA[l].has(i):
				DATA[l].get_or_add(i, false)
				print(i)
		for i in SAVE_DEFAULT.progression_stage:
			if not DATA[l].progression_stage.has(i):
				DATA[l].progression_stage.get_or_add(i, false)
				print(DATA[l])
	var extra_zero = "0%s"
	var extra_extra_zero = "00%s"
	for i in range(0, 3):
		DATA[i].hour = int(DATA[i].play_time / 360000)
		DATA[i].minute = int(DATA[i].play_time / 60000 - DATA[i].hour * 60)
		if DATA[i].minute < 10:
			DATA[i].minute  = extra_zero % [DATA[i].minute]
		if DATA[i].hour < 10:
			DATA[i].hour = extra_extra_zero % [DATA[i].hour]
		else:
			if DATA[i].hour < 100:
				DATA[i].hour = extra_zero % [DATA[i].hour]
	var treasure_amount_1 = 0
	for value in DATA[0].treasure:
		if value:
			treasure_amount_1 += 1
	var treasure_amount_2 = 0
	for value in DATA[1].treasure:
		if value:
			treasure_amount_2 += 1
	var treasure_amount_3 = 0
	for value in DATA[2].treasure:
		if value:
			treasure_amount_3 += 1
	var time_format = "%s:%s"
	var time_1_display = time_format % [DATA[0].hour, DATA[0].minute]
	var time_2_display = time_format % [DATA[1].hour, DATA[1].minute]
	var time_3_display = time_format % [DATA[2].hour, DATA[2].minute]
	$Control/SaveFiles/SaveFile1/TextureRect/Label4.text = count_format % treasure_amount_1
	$Control/SaveFiles/SaveFile2/TextureRect/Label4.text = count_format % treasure_amount_2
	$Control/SaveFiles/SaveFile3/TextureRect/Label4.text = count_format % treasure_amount_3
	$Control/SaveFiles/SaveFile1/Control/Label.text = time_1_display
	$Control/SaveFiles/SaveFile1/Control/Label2.text = DATA[0].place
	$Control/SaveFiles/SaveFile1/Control/Label3.text = DATA[0].enemy
	$Control/SaveFiles/SaveFile2/Control/Label.text = time_2_display
	$Control/SaveFiles/SaveFile2/Control/Label2.text = DATA[1].place
	$Control/SaveFiles/SaveFile2/Control/Label3.text = DATA[1].enemy
	$Control/SaveFiles/SaveFile3/Control/Label.text = time_3_display
	$Control/SaveFiles/SaveFile3/Control/Label2.text = DATA[2].place
	$Control/SaveFiles/SaveFile3/Control/Label3.text = DATA[2].enemy
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if DATA[0].play_time == 0 and DATA[0].enemy == "Tulto" and DATA[0].place == "none" and DATA[1].enemy_id == 0:
		file_new.file_1 = true
	else:
		file_new.file_1 = false
	if DATA[1].play_time == 0 and DATA[1].enemy == "Tulto" and DATA[1].place == "none" and DATA[1].enemy_id == 0:
		file_new.file_2 = true
	else:
		file_new.file_2 = false
	if DATA[2].play_time == 0 and DATA[2].enemy == "Tulto" and DATA[2].place == "none" and DATA[2].enemy_id == 0:
		file_new.file_3 = true
	else:
		file_new.file_3 = false
	if file_new.file_1 and MODE != "new":
		$Control/SaveFiles/SaveFile1.disabled = true
		$Control/SaveFiles/SaveFile1/Control.visible = false
		$Control/SaveFiles/SaveFile1/TextureRect.visible = false
	else:
		$Control/SaveFiles/SaveFile1.disabled = false
		$Control/SaveFiles/SaveFile1/Control.visible = true
		$Control/SaveFiles/SaveFile1/TextureRect.visible = true
	if file_new.file_2 and MODE != "new":
		$Control/SaveFiles/SaveFile2.disabled = true
		$Control/SaveFiles/SaveFile2/Control.visible = false
		$Control/SaveFiles/SaveFile2/TextureRect.visible = false
	else:
		$Control/SaveFiles/SaveFile2.disabled = false
		$Control/SaveFiles/SaveFile2/Control.visible = true
		$Control/SaveFiles/SaveFile2/TextureRect.visible = true
	if file_new.file_3 and MODE != "new":
		$Control/SaveFiles/SaveFile3.disabled = true
		$Control/SaveFiles/SaveFile3/Control.visible = false
		$Control/SaveFiles/SaveFile3/TextureRect.visible = false
	else:
		$Control/SaveFiles/SaveFile3.disabled = false
		$Control/SaveFiles/SaveFile3/Control.visible = true
		$Control/SaveFiles/SaveFile3/TextureRect.visible = true
	if Autoloads.CURRENT_STATE == "home":
		_ready()
		Autoloads.CURRENT_STATE = "start"
		START = false
		STARTED = false
		$Camera2D.enabled = true
		$Control.visible = true
		print("home_return")
	if START and not STARTED:
		$Control/SaveFiles/SaveFile1.disabled = false
		$Control/SaveFiles/SaveFile1/Control.visible = true
		$Control/SaveFiles/SaveFile2.disabled = false
		$Control/SaveFiles/SaveFile2/Control.visible = true
		$Control/SaveFiles/SaveFile3.disabled = false
		$Control/SaveFiles/SaveFile3/Control.visible = true
		OPENED = false
		$Control/Label.visible = false
		$Control/GameStarts.visible = false
		$Control/SaveFiles.visible = false
		$Control/Return.visible = false
		STARTED = true
		$Camera2D.enabled = false
		$Control.visible = false
		MAIN = preload("res://scenes/misc/main_game_scene.tscn").instantiate()
		add_child(MAIN)
		await get_tree().process_frame
		Autoloads.START_TIME = Time.get_ticks_msec()
		if MODE == "new":
			var SAVE_SAVE_FILE = FileAccess.open("user://save_file.save", FileAccess.READ)
			var SAVE_FILE = FileAccess.open("user://save_1.save", FileAccess.READ)
			if OPEN_FILE == 1:
				SAVE_FILE = FileAccess.open("user://save_1.save", FileAccess.WRITE)
			if OPEN_FILE == 2:
				SAVE_FILE = FileAccess.open("user://save_2.save", FileAccess.WRITE)
			if OPEN_FILE == 3:
				SAVE_FILE = FileAccess.open("user://save_3.save", FileAccess.WRITE)
			SAVE_FILE.store_var(SAVE_SAVE_FILE.get_var())
			SAVE_FILE.close()
			SAVE_SAVE_FILE.close()
			MAIN.call("_tutorial")
	else:
		if Input.is_action_pressed("t"):
			CHARGE += 1
			if CHARGE > 100 and Input.is_action_pressed("l"):
				erase()
				CHARGE = 0
		else:
			CHARGE = 0
		if OPENED:
			$Control/GameStarts.visible = false
			$Control/Label.visible = false
			$Control/SaveFiles.visible = true
			$Control/Return.visible = true
		if not OPENED:
			$Control/Label.visible = true
			$Control/GameStarts.visible = true
			$Control/SaveFiles.visible = false
			$Control/Return.visible = false
func _on_new_game_pressed() -> void:
	OPENED = true
	MODE = "new"
func _on_continue_pressed() -> void:
	OPENED = true
	MODE = "continue"
func _on_save_file_1_pressed() -> void:
	if MODE == "erase":
		var SAVE_1 = FileAccess.open("user://save_1.save", FileAccess.READ_WRITE)
		SAVE_1.store_var(SAVE_DEFAULT)
		DATA[0] = SAVE_DEFAULT
		SAVE_1.close()
	else:
		if MODE == "new":
			$Control/GameStarts.visible = false
			$Control/SaveFiles.visible = false
			$Control/Return.visible = false
			var SAVE_FILE = FileAccess.open("user://save_1.save", FileAccess.READ)
			var SAVE_SAVE_FILE = FileAccess.open("user://save_file.save", FileAccess.WRITE)
			SAVE_SAVE_FILE.store_var(SAVE_FILE.get_var())
			SAVE_FILE.close()
			SAVE_SAVE_FILE.close()
			SAVE_FILE = FileAccess.open("user://save_1.save", FileAccess.WRITE)
			SAVE_FILE.store_var(SAVE_DEFAULT.duplicate())
			SAVE_FILE.close()
		OPEN_FILE = 1
		START = true
		Autoloads.LAST_LOADED = 1
func _on_save_file_2_pressed() -> void:
	if MODE == "erase":
		var SAVE_2 = FileAccess.open("user://save_2.save", FileAccess.READ_WRITE)
		SAVE_2.store_var(SAVE_DEFAULT)
		DATA[1] = SAVE_DEFAULT
		SAVE_2.close()
	else:
		if MODE == "new":
			$Control/GameStarts.visible = false
			$Control/SaveFiles.visible = false
			$Control/Return.visible = false
			var SAVE_FILE = FileAccess.open("user://save_2.save", FileAccess.READ)
			var SAVE_SAVE_FILE = FileAccess.open("user://save_file.save", FileAccess.WRITE)
			SAVE_SAVE_FILE.store_var(SAVE_FILE.get_var())
			SAVE_FILE.close()
			SAVE_SAVE_FILE.close()
			SAVE_FILE = FileAccess.open("user://save_2.save", FileAccess.WRITE)
			SAVE_FILE.store_var(SAVE_DEFAULT.duplicate())
			SAVE_FILE.close()
		OPEN_FILE = 2
		START = true
		Autoloads.LAST_LOADED = 2
func _on_save_file_3_pressed() -> void:
	if MODE == "erase":
		var SAVE_3 = FileAccess.open("user://save_3.save", FileAccess.WRITE)
		SAVE_3.store_var(SAVE_DEFAULT)
		DATA[2] = SAVE_DEFAULT
		SAVE_3.close()
	else:
		if MODE == "new":
			$Control/GameStarts.visible = false
			$Control/SaveFiles.visible = false
			$Control/Return.visible = false
			var SAVE_FILE = FileAccess.open("user://save_3.save", FileAccess.READ)
			var SAVE_SAVE_FILE = FileAccess.open("user://save_file.save", FileAccess.WRITE)
			SAVE_SAVE_FILE.store_var(SAVE_FILE.get_var())
			SAVE_FILE.close()
			SAVE_SAVE_FILE.close()
			SAVE_FILE = FileAccess.open("user://save_3.save", FileAccess.WRITE)
			SAVE_FILE.store_var(SAVE_DEFAULT.duplicate())
			SAVE_FILE.close()
		OPEN_FILE = 3
		START = true
		Autoloads.LAST_LOADED = 3


func _on_return_pressed() -> void:
	OPENED = false
func erase():
	var SAVE_1 = FileAccess.open("user://save_1.save", FileAccess.WRITE)
	SAVE_1.store_var(SAVE_DEFAULT)
	SAVE_1.close()
	var SAVE_2 = FileAccess.open("user://save_2.save", FileAccess.WRITE)
	SAVE_2.store_var(SAVE_DEFAULT)
	SAVE_2.close()
	var SAVE_3 = FileAccess.open("user://save_3.save", FileAccess.WRITE)
	SAVE_3.store_var(SAVE_DEFAULT)
	SAVE_3.close()
func _on_texture_button_pressed() -> void:
	OPENED = true
	MODE = "erase"
