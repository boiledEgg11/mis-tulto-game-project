extends Node2D
var location
var SAVE_STUFF: Dictionary = {
	"place": "none",
	"enemy": "none"
}
func _save(enemy):
	print("saved!")
	SAVE_STUFF = {
		"place": location,
		"enemy": enemy
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
	SAVE_FILE.store_var(SAVE_STUFF.duplicate())
	print("added!")
	SAVE_FILE.close()
	await get_tree().process_frame
	_load_game()
func _save_game():
	var SAVE_FILE = FileAccess.open("user://saves.save", FileAccess.WRITE)
	DirAccess.remove_absolute("user://saves.save")
	print("removed!")
	_save_2()
func _load_game():
	var SAVE_FILE = FileAccess.open("user://saves.save", FileAccess.READ)
	var data = SAVE_FILE.get_var()
	SAVE_FILE.close()
	var SAVE_DATA = data
	SAVE_STUFF.place = data.place
	SAVE_STUFF.enemy = data.enemy
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("i"):
		_save_game()
		print(SAVE_STUFF.place)
		print(SAVE_STUFF.enemy)
	if Input.is_action_just_pressed("j"):
		_load_game()
		Autoloads.location = SAVE_STUFF.place
		Autoloads.POSSESS_ENEMY = SAVE_STUFF.enemy
