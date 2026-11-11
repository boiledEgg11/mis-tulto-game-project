extends StaticBody2D
var characters: Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
@onready var enemies
@onready var enemies_id
@onready var enemy_types
@onready var current_enemy_amount
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _set_enemy(level):
	var enemy_file = FileAccess.open("res://assets/text/enemy_placement.txt", FileAccess.READ)
	var enemy_ids = FileAccess.open("res://assets/text/character_ids.txt", FileAccess.READ)
	var enemy_species = FileAccess.open("res://assets/text/enemy_type.txt", FileAccess.READ)
	var enemy_placement = enemy_file.get_as_text()
	var enemy_id = enemy_ids.get_as_text()
	var enemy_specie = enemy_species.get_as_text()
	enemy_ids.close()
	enemy_file.close()
	print("working...")
	enemy_species.close()
	enemies_id = enemy_id.split("\n")
	enemies = enemy_placement.split("\n")
	enemy_types = enemy_specie.split("\n")
	for i in range(enemy_types.size()):
		if enemy_types[i] == "_stop":
			print("stop!")
			break
		current_enemy_amount = i
		match enemy_types[i]:
			"enemy_1":
				characters[i] = preload("res://scenes/enemy1.tscn").instantiate()
			"enemy_2":
				characters[i] = preload("res://scenes/enemy2.tscn").instantiate()
			"enemy_3":
				characters[i] = preload("res://scenes/enemy3.tscn").instantiate()
			"enemy_4":
				characters[i] = preload("res://scenes/enemy4.tscn").instantiate()
			"enemy_5":
				characters[i] = preload("res://scenes/enemy5.tscn").instantiate()
			"enemy_6":
				characters[i] = preload("res://scenes/enemy6.tscn").instantiate()
			"enemy_7":
				characters[i] = preload("res://scenes/enemy7.tscn").instantiate()
			"save":
				characters[i] = preload("res://scenes/save.tscn").instantiate()
		owner.add_child.call_deferred(characters[i])
		match enemies[i]:
			"enemy":
				characters[i].call("_individual_set", int(enemies_id[i]))
				print(enemies_id)
			"save":
				characters[i].call("_placement", enemies_id[i])
			_:
				print("missing type...")
func _erase_enemy():
	for i in range(current_enemy_amount):
		match enemies[i]:
			"enemy":
				if characters[i].get_child(0).possess_health > 0:
					characters[i].call_deferred("_erase")
					characters[i] = preload("res://scenes/empty.tscn").instantiate()
			"save":
				characters[i].call_deferred("_erase")
				characters[i] = preload("res://scenes/empty.tscn").instantiate()
