extends TileMapLayer
@onready var tile_move_value = Vector2(0, 0)
var initial_pos
func _ready() -> void:
	initial_pos = position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Autoloads.spin_moving:
		position.y += tile_move_value.y
	if position.y > initial_pos.y - 62 and Autoloads.tile_move > 0:
		tile_move_value.y = 2
	if position.y < initial_pos.y + 62 and Autoloads.tile_move < 0:
		tile_move_value.y = -2
	if position.y < initial_pos.y - 62 or position.y > initial_pos.y + 62 or Autoloads.tile_move == 0:
		tile_move_value.y = 0
	if position.y < initial_pos.y - 62:
		position.y += 0.1
	if position.y > initial_pos.y + 62:
		position.y -= 0.1
