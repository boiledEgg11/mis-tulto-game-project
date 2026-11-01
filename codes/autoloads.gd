extends Node

var PLAYER_POSITION_X = 0
var PLAYER_POSITION_Y = 0
var POSSESS_SPRITE = "none"
var PLAYER_POSSESSING = false
var PLAYER_POSSESS_STOP = false
var POSSESS_AMOUNT = 0
var POSSESS_ENEMY
var PROGRESSION
var tile
var POSSESS_TYPE
var tile_move = 0
var move_amount = false
var is_moving = true
var POSSESS_ABILITY = "none"
var POSSESS_STATUS = {"speed": 0, "jump": 0, "slide": 0, "damage_multiplier": 0, "hitbox_y": 0, "hitbox_x": 0}
# Called when the node enters the scene tree for the first time.
