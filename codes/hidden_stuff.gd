extends Node2D
@onready var treasure_id: int
func _erase():
	queue_free()
func _placement(placement):
	match placement:
		"treasure_1":
			position = Vector2i(232, 136)
	treasure_id = int(placement)
func _found(collider):
	Autoloads.FOUND_TREASURE[treasure_id] = true
	collider.get_parent().call_deferred("_open_text", 8, true)
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Autoloads.FOUND_TREASURE[treasure_id]:
		_erase()
