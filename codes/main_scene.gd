extends Node2D
var MAIN
var OPENED = false
var MODE = "new"
var START = false
var STARTED = false
var OPEN_FILE = 1
var CHARGE = 0
var file_new: Dictionary = {
	"file_1": false,
	"file_2": false,
	"file_3": false
}
var SAVE_DEFAULT: Dictionary = {
	"place": "none",
	"enemy": "none",
	"enemy_id": 0,
	"play_time": 0
}
func _ready() -> void:
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
	var SAVE_ACCESS_1 = FileAccess.open("user://save_1.save", FileAccess.READ)
	var SAVE_ACCESS_2 = FileAccess.open("user://save_2.save", FileAccess.READ)
	var SAVE_ACCESS_3 = FileAccess.open("user://save_3.save", FileAccess.READ)
	var DATA_1 = SAVE_ACCESS_1.get_var()
	var DATA_2 = SAVE_ACCESS_2.get_var()
	var DATA_3 = SAVE_ACCESS_3.get_var()
	if DATA_1 == SAVE_DEFAULT:
		file_new.file_1 = true
	if DATA_2 == SAVE_DEFAULT:
		file_new.file_2 = true
	if DATA_3 == SAVE_DEFAULT:
		file_new.file_3 = true
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
	$Control/SaveFiles/SaveFile1/Control/Label.text = time_1_display
	$Control/SaveFiles/SaveFile1/Control/Label2.text = DATA_1.place
	$Control/SaveFiles/SaveFile1/Control/Label3.text = DATA_1.enemy
	$Control/SaveFiles/SaveFile2/Control/Label.text = time_2_display
	$Control/SaveFiles/SaveFile2/Control/Label2.text = DATA_2.place
	$Control/SaveFiles/SaveFile2/Control/Label3.text = DATA_2.enemy
	$Control/SaveFiles/SaveFile3/Control/Label.text = time_3_display
	$Control/SaveFiles/SaveFile3/Control/Label2.text = DATA_3.place
	$Control/SaveFiles/SaveFile3/Control/Label3.text = DATA_3.enemy
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if file_new.file_1 and MODE == "continue":
		$Control/SaveFiles/SaveFile1.disabled = true
		$Control/SaveFiles/SaveFile1/Control.visible = false
	else:
		$Control/SaveFiles/SaveFile1.disabled = false
		$Control/SaveFiles/SaveFile1/Control.visible = true
	if file_new.file_2 and MODE == "continue":
		$Control/SaveFiles/SaveFile2.disabled = true
		$Control/SaveFiles/SaveFile2/Control.visible = false
	else:
		$Control/SaveFiles/SaveFile2.disabled = false
		$Control/SaveFiles/SaveFile2/Control.visible = true
	if file_new.file_3 and MODE == "continue":
		$Control/SaveFiles/SaveFile3.disabled = true
		$Control/SaveFiles/SaveFile3/Control.visible = false
	else:
		$Control/SaveFiles/SaveFile3.disabled = false
		$Control/SaveFiles/SaveFile3/Control.visible = true
	if Autoloads.CURRENT_STATE == "home":
		Autoloads.CURRENT_STATE = "start"
		START = false
		STARTED = false
		$Camera2D.enabled = true
		$Control.visible = true
		print("home_return")
	if START and not STARTED:
		OPENED = false
		$Control/Label.visible = false
		$Control/GameStarts.visible = false
		$Control/SaveFiles.visible = false
		$Control/Return.visible = false
		STARTED = true
		$Camera2D.enabled = false
		$Control.visible = false
		MAIN = preload("res://main_game_scene.tscn").instantiate()
		add_child(MAIN)
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
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
