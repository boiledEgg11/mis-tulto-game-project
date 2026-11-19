extends Node2D
var child = get_child(0)
func _erase():
	if child.name == "Enemy8":
		for i in 5:
			if child.projectile[i].name == "Enemy8_projectile":
				child.projectile[i].call_deferred("_screen_not_visible")
	queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _possess_start():
	child.possess_health = 0
	child.call_deferred("_possess_start")
func _process(delta: float) -> void:
	if Autoloads.RESET:
		free()
func _possessed():
	Autoloads.POSSESS_ENEMY = child
func _individual_set(individual_set):
	if get_child(0).name != "EnemyTest3":
		get_child(0).individual = individual_set
	else:
		get_child(0).stats.individual = individual_set
	get_child(0).START = true
