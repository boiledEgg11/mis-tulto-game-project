extends TileMapLayer
var initial_pos
func _ready() -> void:
	initial_pos = position.y
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if position.y > initial_pos - 80 and position.y <= initial_pos:
		print("movable")
		position.y -= Autoloads.tile_move / 2
		Autoloads.is_moving_2 = true
	else:
		Autoloads.is_moving_2 = false
		if initial_pos > position.y:
			if Autoloads.move_amount:
				position.y = initial_pos - 79.9
			else:
				position.y = initial_pos - 80
		if initial_pos < position.y:
			if Autoloads.move_amount:
				position.y = initial_pos 
			else:
				position.y = initial_pos + 0.1
