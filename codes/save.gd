extends Node2D
var location

func _placement(placement):
	match placement:
		"test_1":
			position = Vector2i(232, 136)
		"test_2":
			position = Vector2i(360, -8)
		_:
			queue_free()
	$Savepoint.location = placement
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
