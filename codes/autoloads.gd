extends Node
@onready var ENEMY_POSSESS: Dictionary = {
	"species": null,
	"individual": null
}
@onready var progression: Array = [0]
@export var progression_side = [0, 0]
@export var player: Node2D
@export var tile_move: int = 0
var tiles: Array
var RESET = false
var PLAYER_POSITION_X = 0
var PLAYER_POSITION_Y = 0
var PLAYER_POSSESSING = false
var PLAYER_POSSESS_STOP = false
var POSSESS_AMOUNT = 0
var POSSESS_ENEMY
var location
var tile
var SAVE_SCREEN
var PLAYER_ATTACK = false
var move_amount = false
var CAMERA_LOCATION = Vector2i(0, 0)
var PAUSE = false
var LAST_LOADED = 1
var play_time = 0
var recorded_time = 0
var is_moving: bool
var is_moving_2: bool
var spin_moving = false
var FOUND_TREASURE = [false, false, false, false, false]
var played_time: Dictionary = {
	"minute": 0,
	"hour": 0
}
var CURRENT_STATE = "home"
var SAVE_STUFF: Dictionary = {
	"place": "none",
	"enemy": "Tulto",
	"enemy_id": 0,
	"play_time": 0,
	"treasure": [false, false, false],
	"progression_stage": [0],
	"progression_side": [0, 0]
}
var START_TIME: int
@onready var center 
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
	if SAVE_DATA.treasure:
		SAVE_STUFF.treasure = SAVE_DATA.treasure
	START_TIME = Time.get_ticks_msec()
	location = Autoloads.SAVE_STUFF.place
	ENEMY_POSSESS.species = Autoloads.SAVE_STUFF.enemy
	ENEMY_POSSESS.individual = Autoloads.SAVE_STUFF.enemy_id
	recorded_time = Autoloads.SAVE_STUFF.play_time
	FOUND_TREASURE = Autoloads.SAVE_STUFF.treasure
