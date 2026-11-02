extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _individual_set(individual_set):
	$EnemyTest6.individual = individual_set
	$EnemyTest6.START = true
