extends AnimatedSprite2D
var characters: Array
@onready var enemies
@onready var enemies_id
@onready var enemy_types

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _enemy_place():
	var enemy_file = FileAccess.open("res://assets/text/enemy_placement.txt", FileAccess.READ)
	var enemy_ids = FileAccess.open("res://assets/text/character_ids.txt", FileAccess.READ)
	var enemy_species = FileAccess.open("res://assets/text/enemy_type.txt", FileAccess.READ)
	var enemy_placement = enemy_file.get_as_text()
	var enemy_id = enemy_ids.get_as_text()
	var enemy_specie = enemy_species.get_as_text()
	enemy_ids.close()
	enemy_file.close()
	enemy_species.close()
	enemies_id = enemy_id.split("\n")
	enemies = enemy_placement.split("\n")
	enemy_types = enemy_specie.split("\n")
	for i in range(enemy_types.size()):
		if enemy_types[i] == "_stop":
			break
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
		match enemies:
			"enemy":
				characters[i].call("_individual_set", enemies_id[i])
			"save":
				characters[i].call("_placement", enemies_id[i])
