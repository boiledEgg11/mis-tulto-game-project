extends TileMapLayer
@onready var initial_pos: Vector2
@onready var move_amount: Vector2 = Vector2(2, 0)
func _ready() -> void:
	initial_pos.x = position.x
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if position.x > initial_pos.x - 80:
		if move_amount.x > 0:
			position.x += move_amount.x
	if position.x < initial_pos.x + 100:
		if move_amount.x < 0:
			position.x += move_amount.x
	if initial_pos.x > position.x:
			position.x = initial_pos.x - 80
	if initial_pos.x < position.x:
			position.x = initial_pos.x + 100
	move_amount.x = Autoloads.tile_move[0]
