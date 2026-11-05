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
var POSSESS_TYPE
var tile_move = 0
var move_amount = false
var is_moving = true
var is_moving_2 = true
var CAMERA_LOCATION = Vector2i(0, 0)
var POSSESS_ABILITY = "none"
var PAUSE = false
var SAVE_STUFF: Dictionary = {
	"place": "none",
	"enemy": "none",
	"enemy_id": 0
}
var POSSESS_STATUS = {"speed": 0, "jump": 0, "slide": 0, "damage_multiplier": 0, "hitbox_y": 0, "hitbox_x": 0}
# Called when the node enters the scene tree for the first time.
func _load_game():
	var SAVE_FILE = FileAccess.open("user://saves.save", FileAccess.READ)
	var data = SAVE_FILE.get_var()
	SAVE_FILE.close()
	var SAVE_DATA = data
	SAVE_STUFF.place = SAVE_DATA.place
	SAVE_STUFF.enemy = SAVE_DATA.enemy
	SAVE_STUFF.enemy_id = SAVE_DATA.enemy_id
	Autoloads.location = Autoloads.SAVE_STUFF.place
	Autoloads.POSSESS_TARGET.species = Autoloads.SAVE_STUFF.enemy
	Autoloads.POSSESS_TARGET.individual = Autoloads.SAVE_STUFF.enemy_id
