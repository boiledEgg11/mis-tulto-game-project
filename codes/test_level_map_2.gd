extends Node2D

func _erase():
	queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _puzzle_solved():
	for i in range(3, 6):
		for l in range(-69, -67):
			$TileMapLayer5.erase_cell(Vector2i(l, i))
