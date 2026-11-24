extends TileMapLayer
@onready var initial_pos: Vector2
@onready var tile_move_value: Vector2 = Vector2(0, 0)
@onready var can_move: bool = false
func _ready() -> void:
	initial_pos = position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if position.y >= initial_pos.y - 80:
		if tile_move_value.y > 0:
			position.y += tile_move_value.y
			can_move = true
		else:
			can_move = false
	if position.y <= initial_pos.y:
		if tile_move_value.y < 0:
			position.y += tile_move_value.y
			can_move = true
		else:
			can_move = false
	if initial_pos.y - 80 > position.y:
			position.y = initial_pos.y - 80
	if initial_pos.y < position.y:
			position.y = initial_pos.y
	tile_move_value.y = Autoloads.tile_move[1]
	if Input.is_action_pressed("4"):
		print(Autoloads.tile_move)
