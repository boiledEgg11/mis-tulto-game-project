extends TileMapLayer
var initial_pos
func _ready() -> void:
	initial_pos = position.x
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if position.x > initial_pos - 80 and position.x < initial_pos + 100:
		position.x += Autoloads.tile_move
		Autoloads.is_moving = true
	else:
		Autoloads.is_moving = false
		if initial_pos > position.x:
			if Autoloads.move_amount:
				position.x = initial_pos - 79.9
			else:
				position.x = initial_pos - 80
		if initial_pos < position.x:
			if Autoloads.move_amount:
				position.x = initial_pos + 99.9
			else:
				position.x = initial_pos + 100
