extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _possess_start():
	$EnemyTest4.call("_possess_start")
func _process(delta: float) -> void:
	if Autoloads.RESET:
		free()
func _individual_set(individual_set):
	$EnemyTest4.individual = individual_set
	$EnemyTest4.START = true
