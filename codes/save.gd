extends Node2D
var location
func _erase():
	$Savepoint.call("_erase")
	queue_free()
func _save(enemy, file):
	print("saved!")
	Autoloads.SAVE_STUFF = {
		"place": location,
		"enemy": Autoloads.POSSESS_TARGET.species,
		"enemy_id": Autoloads.POSSESS_TARGET.individual,
		"play_time": Autoloads.play_time
	}
	_save_game(file)
func _placement(placement):
	match placement:
		"test_1":
			position = Vector2i(232, 136)
		"test_2":
			position = Vector2i(360, -8)
		"test_3":
			position = Vector2i(1048, -56)
		"test_4":
			position = Vector2(-24, 24)
		"test_5":
			position = Vector2(-1050, 24)
		"test_6":
			position = Vector2(-24, 24)
		_:
			queue_free()
	location = placement
func _save_2(file):
	var SAVE_FILE
	if file == 1:
		print("file 1")
		SAVE_FILE = FileAccess.open("user://save_1.save", FileAccess.WRITE)
	if file == 2:
		print("file 2")
		SAVE_FILE = FileAccess.open("user://save_2.save", FileAccess.WRITE)
	if file == 3:
		print("file 3")
		SAVE_FILE = FileAccess.open("user://save_3.save", FileAccess.WRITE)
	await get_tree().process_frame
	SAVE_FILE.store_var(Autoloads.SAVE_STUFF.duplicate())
	print("added!")
	SAVE_FILE.close()
	await get_tree().process_frame
func _save_game(file):
	var SAVE_FILE
	if file == 1:
		SAVE_FILE = FileAccess.open("user://save_1.save", FileAccess.WRITE)
		DirAccess.remove_absolute("user://save_1.save")
	if file == 2:
		SAVE_FILE = FileAccess.open("user://save_2.save", FileAccess.WRITE)
		DirAccess.remove_absolute("user://save_2.save")
	if file == 3:
		SAVE_FILE = FileAccess.open("user://save_3.save", FileAccess.WRITE)
		DirAccess.remove_absolute("user://save_3.save")
	print("removed!")
	_save_2(file)
func _process(delta: float) -> void:
	if Autoloads.RESET:
		queue_free()
