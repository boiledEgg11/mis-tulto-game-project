extends TileMapLayer
@onready var initial_pos: Vector2
@onready var tile_move_value: Vector2 = Vector2(0, 0)
@onready var can_move: bool = false
func _ready() -> void:
	initial_pos.x = position.x
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if position.x >= initial_pos.x:
		if tile_move_value.x > 0:
			position.x += tile_move_value.x
			can_move = true
		else:
			can_move = false
	if position.x <= initial_pos.x + 136:
		if tile_move_value.x < 0:
			position.x += tile_move_value.x
			can_move = true
		else:
			can_move = false
	if position.x <= -128:
		if not is_in_group("background_guard"):
			add_to_group("background_guard")
	else:
		if is_in_group("background_guard"):
			remove_from_group("background_guard")
	if initial_pos.x > position.x:
			position.x = initial_pos.x
	if initial_pos.x + 136 < position.x:
			position.x = initial_pos.x + 136
	tile_move_value.x = Autoloads.tile_move[3] * -1
