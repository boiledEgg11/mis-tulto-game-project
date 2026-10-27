extends TileMapLayer
var move_amount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (move_amount >= -82 and Autoloads.tile_move < 0) or (move_amount <= 100 and Autoloads.tile_move > 0):
		move_amount += Autoloads.tile_move
	if move_amount > -82 and move_amount < 100:
		position.x += Autoloads.tile_move
