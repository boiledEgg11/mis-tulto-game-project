extends TileMapLayer
@onready var tile_move_value = Vector2(-3, 0)
@onready var initial_pos
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += tile_move_value
	if position.x < initial_pos.x:
		tile_move_value.x = 3
	if position.x > initial_pos.x + 120:
		tile_move_value.x = -3
	
