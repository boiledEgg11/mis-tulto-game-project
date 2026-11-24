extends TileMapLayer
@onready var initial_pos: Vector2
@onready var move_amount: Vector2 = Vector2(2, 0)
func _ready() -> void:
	initial_pos = position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if position.y > initial_pos.y - 62:
		if move_amount.y > 0:
			position.y += move_amount.y
	if position.y < initial_pos.y + 62:
		if move_amount.y < 0:
			position.y += move_amount.y
	if initial_pos.y > position.y:
			position.y = initial_pos.y - 62
	if initial_pos.y < position.y + 62:
			position.y = initial_pos.y
	move_amount.y = Autoloads.tile_move[2]
