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
	print(SAVE_STUFF)
func _placement(placement):
	match placement:
		"test_1":
			position = Vector2i(232, 136)
		"test_2":
			position = Vector2i(360, -8)
		_:
			queue_free()
	location = placement
func _save_game():
	var SAVE_FILE = FileAccess.open("user://saves.save", FileAccess.WRITE)
	SAVE_FILE.store_var(SAVE_STUFF.duplicate())
	SAVE_FILE.close()
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
		print(SAVE_STUFF.place)
		print(SAVE_STUFF.enemy)
	
