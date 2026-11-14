extends Node2D

func _erase():
	queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if i is TileMapLayer:
			Autoloads.tiles.append(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
