extends StaticBody2D
var enemy1 = preload("res://scenes/enemy1.tscn").instantiate()
var enemy2 = preload("res://scenes/enemy2.tscn").instantiate()
var enemy3 = preload("res://scenes/enemy3.tscn").instantiate()
var enemy4 = preload("res://scenes/enemy4.tscn").instantiate()
var enemy5 = preload("res://scenes/enemy5.tscn").instantiate()
var enemy6 = preload("res://scenes/enemy6.tscn").instantiate()
var enemy7 = preload("res://scenes/enemy7.tscn").instantiate()
var enemy1_1 = preload("res://scenes/enemy1.tscn").instantiate()
func _set_enemy():
	owner.add_child.call_deferred(enemy1_1)
	owner.add_child.call_deferred(enemy1)
	owner.add_child.call_deferred(enemy2)
	owner.add_child.call_deferred(enemy3)
	owner.add_child.call_deferred(enemy4)
	owner.add_child.call_deferred(enemy5)
	owner.add_child.call_deferred(enemy6)
	owner.add_child.call_deferred(enemy7)
	enemy1.individual = 1
	enemy2.individual = 1
	enemy3.individual = 1
	enemy4.individual = 1
	enemy5.individual = 1
	enemy6.individual = 1
	enemy7.individual = 1
	enemy1_1.individual = 2
func _ready() -> void:
	_set_enemy()
