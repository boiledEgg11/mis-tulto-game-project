extends Node2D
func _erase():
	queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _possess_start():
	get_child(0).call("_possess_start")
func _process(delta: float) -> void:
	if Autoloads.RESET:
		free()
func _individual_set(individual_set):
	get_child(0).individual = individual_set
	get_child(0).START = true
