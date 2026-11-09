extends Node
var POSSESS_TARGET = {"species": "none", "individual": "0"}
var RESET = false
var PLAYER_POSITION_X = 0
var PLAYER_POSITION_Y = 0
var POSSESS_SPRITE = "none"
var PLAYER_POSSESSING = false
var PLAYER_POSSESS_STOP = false
var POSSESS_AMOUNT = 0
var POSSESS_ENEMY
var location
var tile
var PLAYER_ATTACK = false
var POSSESS_TYPE
var tile_move = 0
var move_amount = false
var is_moving = true
var is_moving_2 = true
var CAMERA_LOCATION = Vector2i(0, 0)
var POSSESS_ABILITY = "none"
var PAUSE = false
var LAST_LOADED = 1
var play_time = 0
var recorded_time = 0
var played_time: Dictionary = {
	"minute": 0,
	"hour": 0
}
var CURRENT_STATE = "home"
var SAVE_STUFF: Dictionary = {
	"place": "none",
	"enemy": "none",
	"enemy_id": 0,
	"play_time": 0
}
var START_TIME: int
var POSSESS_STATUS = {"speed": 0, "jump": 0, "slide": 0, "damage_multiplier": 0, "hitbox_y": 0, "hitbox_x": 0}

func _load_game(file):
	LAST_LOADED = file
	var SAVE_FILE
	if file == 1:
		print("file 1")
		SAVE_FILE = FileAccess.open("user://save_1.save", FileAccess.READ)
	if file == 2:
		print("file 2")
		SAVE_FILE = FileAccess.open("user://save_2.save", FileAccess.READ)
	if file == 3:
		print("file 3")
		SAVE_FILE = FileAccess.open("user://save_3.save", FileAccess.READ)
	var data = SAVE_FILE.get_var()
	SAVE_FILE.close()
	var SAVE_DATA = data
	if SAVE_DATA.place:
		SAVE_STUFF.place = SAVE_DATA.place
	if SAVE_DATA.enemy:
		SAVE_STUFF.enemy = SAVE_DATA.enemy
	if SAVE_DATA.enemy_id:
		SAVE_STUFF.enemy_id = SAVE_DATA.enemy_id
	if SAVE_DATA.play_time:
		SAVE_STUFF.play_time = SAVE_DATA.play_time
	START_TIME = Time.get_ticks_msec()
	Autoloads.location = Autoloads.SAVE_STUFF.place
	Autoloads.POSSESS_TARGET.species = Autoloads.SAVE_STUFF.enemy
	Autoloads.POSSESS_TARGET.individual = Autoloads.SAVE_STUFF.enemy_id
	Autoloads.recorded_time = Autoloads.SAVE_STUFF.play_time
