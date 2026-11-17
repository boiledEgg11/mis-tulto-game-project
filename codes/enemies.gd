extends Node2D
func _erase():
	if get_child(0, false).name == "Enemy8":
		for i in 5:
			if get_child(0).projectile[i].name == "Enemy8_projectile":
				get_child(0).projectile[i].call_deferred("_screen_not_visible")
	queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _possess_start():
	get_child(0).possess_health = 0
	get_child(0).call_deferred("_possess_start")
func _process(delta: float) -> void:
	if Autoloads.RESET:
		free()
func _possessed():
	Autoloads.ENEMY_POSSESS = get_child(0)
func _individual_set(individual_set):
	get_child(0).individual = individual_set
	get_child(0).START = true
