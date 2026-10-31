extends TileMapLayer
var initial_pos
func _ready() -> void:
	initial_pos = position.x
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Autoloads.move_amount = position.x - initial_pos
	if position.x > initial_pos - 80 and position.x < initial_pos + 100:
		position.x += Autoloads.tile_move
	else:
		if initial_pos > position.x:
			position.x = initial_pos - 79.9
		if initial_pos < position.x:
			position.x = initial_pos + 99.9
