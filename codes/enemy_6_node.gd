extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _possess_start():
	$EnemyTest6.possess_health = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Autoloads.RESET:
		queue_free()
func _individual_set(individual_set):
	$EnemyTest6.individual = individual_set
	$EnemyTest6.START = true
