extends Node2D
@onready var possessed:bool = false
@export var child: Node2D
func _erase():
	if child:
		child.queue_free()
		if child.name == "Enemy8":
			for i in 5:
				if child.projectile[i].name == "Enemy8_projectile":
					child.projectile[i].call_deferred("_screen_not_visible")
	if is_instance_valid(child):
		child.queue_free()
	queue_free()

func _possess_start():
	child.possess_health = 0
	child.call_deferred("_possess_start")
func _process(delta: float) -> void:
	if get_child_count() != 0:
		if is_instance_valid(child):
			if child.possess_health == 0:
				possessed = true
func _possessed():
	Autoloads.POSSESS_ENEMY = child
func _possess_end():
	possessed = false
func _individual_set(individual_set):
	child.stats.individual = individual_set
	child.START = true
