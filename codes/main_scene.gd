extends Node2D
var MAIN
var OPENED = false
var MODE = "new"
var START = false
var STARTED = false
var OPEN_FILE = 1
func _process(delta: float) -> void:
	if START and not STARTED:
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
		if OPENED:
			$Control/GameStarts.visible = false
			$Control/SaveFiles.visible = true
			$Control/Return.visible = true
		if not OPENED:
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
		print(SAVE_FILE.get_var())
		print(SAVE_SAVE_FILE.get_var())
		SAVE_FILE.close()
		SAVE_SAVE_FILE.close()
		SAVE_FILE = FileAccess.open("user://save_1.save", FileAccess.WRITE)
		SAVE_FILE.store_var(Autoloads.SAVE_STUFF.duplicate())
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
		SAVE_FILE.store_var(Autoloads.SAVE_STUFF.duplicate())
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
		SAVE_FILE.store_var(Autoloads.SAVE_STUFF.duplicate())
		SAVE_FILE.close()
	OPEN_FILE = 3
	START = true
	Autoloads.LAST_LOADED = 3


func _on_return_pressed() -> void:
	OPENED = false
