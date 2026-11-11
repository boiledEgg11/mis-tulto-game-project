extends TileMapLayer
@onready var tile_rotate_value = 2
@onready var initial_pos
@onready var moving
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pos = position
	await get_tree().process_frame
	await get_tree().process_frame
	moving = true
func _spin():
	if moving:
		rotation_degrees += tile_rotate_value
func _process(delta: float) -> void:
	_spin()
