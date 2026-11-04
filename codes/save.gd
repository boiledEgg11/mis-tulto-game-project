extends Node2D
var location

func _save(enemy):
	print("saved!")
	Autoloads.SAVE_STUFF = {
		"place": location,
		"enemy": Autoloads.POSSESS_TARGET.species,
		"enemy_id": Autoloads.POSSESS_TARGET.individual
	}
	_save_game()
func _placement(placement):
	match placement:
		"test_1":
			position = Vector2i(232, 136)
		"test_2":
			position = Vector2i(360, -8)
		_:
			queue_free()
	location = placement
func _save_2():
	var SAVE_FILE = FileAccess.open("user://saves.save", FileAccess.WRITE)
	SAVE_FILE.store_var(Autoloads.SAVE_STUFF.duplicate())
	print("added!")
	SAVE_FILE.close()
	await get_tree().process_frame
func _save_game():
	var SAVE_FILE = FileAccess.open("user://saves.save", FileAccess.WRITE)
	DirAccess.remove_absolute("user://saves.save")
	print("removed!")
	_save_2()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("i"):
		_save_game()
		print(Autoloads.SAVE_STUFF.place)
		print(Autoloads.SAVE_STUFF.enemy)
	if Autoloads.RESET:
		queue_free()
