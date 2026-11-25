extends Node2D
@onready var possessed:bool = false
@export var child: Node2D
func _erase():
	if child:
		child.queue_free()
		if child.name == "Enemy8":
			for i in 5:
				if get_child(0).projectile[i].name == "Enemy8_projectile":
					get_child(0).projectile[i].call_deferred("_screen_not_visible")
	if is_instance_valid(child):
		child.queue_free()
	queue_free()
func _ready() -> void:
	if is_instance_valid(get_child(0)):
		child = get_child(0)
func _possess_start():
	get_child(0).possess_health = 0
	get_child(0).call_deferred("_possess_start")
func _process(delta: float) -> void:
	if get_child_count() != 0:
		if is_instance_valid(get_child(0)):
			if get_child(0).possess_health == 0:
				possessed = true
func _possessed():
	Autoloads.POSSESS_ENEMY = get_child(0)
func _possess_end():
	possessed = false
func _individual_set(individual_set):
	get_child(0).stats.individual = individual_set
	get_child(0).START = true
