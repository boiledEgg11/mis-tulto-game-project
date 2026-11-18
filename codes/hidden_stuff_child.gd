extends StaticBody2D
func _erase():
	get_parent().call_deferred("_erase")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _found(collider):
	get_parent().call_deferred("_found", collider)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
