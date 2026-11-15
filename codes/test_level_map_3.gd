extends Node2D
@onready var puzzle_amount = 0
func _erase():
	queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if i is TileMapLayer:
			Autoloads.tiles.append(i)

func _puzzle_solved():
	puzzle_amount += 1
	if puzzle_amount == 2:
		for i in range(-33, -30):
			$TileMapLayer2.erase_cell(Vector2i(i, 5))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
