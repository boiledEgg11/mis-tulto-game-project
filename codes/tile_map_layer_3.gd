extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Autoloads.move_amount >= -82 and Autoloads.tile_move < 0) or (Autoloads.move_amount <= 100 and Autoloads.tile_move > 0):
		Autoloads.move_amount += Autoloads.tile_move
	if Autoloads.move_amount > -82 and Autoloads.move_amount < 100:
		position.x += Autoloads.tile_move
