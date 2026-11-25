extends StaticBody2D
var characters: Array[Node2D]
@onready var enemies
@onready var enemies_id
@onready var enemy_types
@onready var file_start_point: int
@onready var current_enemy_amount
@onready var loaded: bool = false
@onready var POSSESS_ENEMY: Node2D
@onready var raid: bool
@onready var raid_enemy: Array[Node2D]
@onready var raid_child: Array[Node2D]
@onready var raid_enemies: Array[bool]
@onready var raid_target: Array[Node2D]
@onready var current_raid_area: Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Autoloads.center = self
func _raid_area(area):
	current_raid_area = area
func raid_end():
	raid = false
	print("win!")
	raid_enemy.clear()
	raid_enemies.clear()
	if current_raid_area != null:
		current_raid_area.call_deferred("_raid_end")
func alive_check(alive):
	return alive == true
func _process(delta: float) -> void:
	if raid:
		if raid_enemies.all(alive_check) and raid:
			raid_end()
		for i in range(raid_target.size()):
			if is_instance_valid(raid_enemy[i]):
				if raid_enemy[i].possessed:
					raid_enemies[i] = true
				if not raid_enemy[i].possessed:
					raid_enemies[i] = false
			else:
				raid_enemies[i] = true
func _read_data(start, level):
	loaded = true
	var enemy_file = FileAccess.open("res://assets/text/enemy_placement.txt", FileAccess.READ)
	var enemy_ids = FileAccess.open("res://assets/text/character_ids.txt", FileAccess.READ)
	var enemy_species = FileAccess.open("res://assets/text/enemy_type.txt", FileAccess.READ)
	var enemy_placement = enemy_file.get_as_text()
	var enemy_id = enemy_ids.get_as_text()
	var enemy_specie = enemy_species.get_as_text()
	enemy_ids.close()
	enemy_file.close()
	print("reading data")
	enemy_species.close()
	enemies_id = enemy_id.split("\n")
	enemies = enemy_placement.split("\n")
	enemy_types = enemy_specie.split("\n")
	characters.resize(enemies.size())
	if start:
		_set_enemy(level)
func _set_enemy(level):
	raid = false
	match  level:
		0:
			file_start_point = 0
		1:
			file_start_point = 13
		2:
			file_start_point = 23
		3:
			file_start_point = 29
		4:
			file_start_point = 37
		"raid_1":
			raid = true
			file_start_point = 34
		"raid_2":
			raid = true
			file_start_point = 39
	for i in range(file_start_point, enemy_types.size()):
		if enemy_types[i] == "_stop" or enemy_types[i] == null:
			break
		current_enemy_amount = i
		match enemy_types[i]:
			"enemy_1":
				characters[i] = preload("res://scenes/enemy/enemy1.tscn").instantiate()
			"enemy_2":
				characters[i] = preload("res://scenes/enemy/enemy2.tscn").instantiate()
			"enemy_3":
				characters[i] = preload("res://scenes/enemy/enemy3.tscn").instantiate()
			"enemy_4":
				characters[i] = preload("res://scenes/enemy/enemy4.tscn").instantiate()
			"enemy_5":
				characters[i] = preload("res://scenes/enemy/enemy5.tscn").instantiate()
			"enemy_6":
				characters[i] = preload("res://scenes/enemy/enemy6.tscn").instantiate()
			"enemy_7":
				characters[i] = preload("res://scenes/enemy/enemy7.tscn").instantiate()
			"enemy_8":
				characters[i] = preload("res://scenes/enemy/enemy8.tscn").instantiate()
			"enemy_9":
				characters[i] = preload("res://scenes/enemy/enemy9.tscn").instantiate()
			"save":
				characters[i] = preload("res://scenes/misc/save.tscn").instantiate()
			"treasure":
				characters[i] = preload("res://scenes/misc/hidden_stuff.tscn").instantiate()
		owner.add_child.call_deferred(characters[i])
		match enemies[i]:
			"enemy":
				print("placed enemies")
				characters[i].call("_individual_set", int(enemies_id[i]))
			"save":
				print("placed saves")
				characters[i].call("_placement", enemies_id[i])
			"treasure":
				print("treasure added")
				characters[i].call("_placement", enemies_id[i])
			_:
				print("missing type...")
		if raid:
			match level:
				"raid_1":
					characters[i].global_position = Vector2(-1160, -56)
				"raid_2":
					characters[i].global_position = Vector2(416, 0)
					print(characters[i])
			raid_enemy.append(characters[i])
			raid_enemies.resize(raid_enemy.size())
			for m in raid_enemy:
				raid_target = raid_enemy
func _force_erase():
	if loaded:
		print("force erased!")
		for i in range(enemies.size()):
			match enemies[i]:
				"enemy":
					print(typeof(characters[i]))
					if is_instance_valid(characters[i]):
						characters[i].call_deferred("_erase")
				"save":
					if is_instance_valid(characters[i]):
						characters[i].call_deferred("_erase")
				"treasure":
					if is_instance_valid(characters[i]):
						characters[i].call_deferred("_erase")
		if is_instance_valid(POSSESS_ENEMY):
			POSSESS_ENEMY.call_deferred("_erase")
	get_parent().call_deferred("_erase_finish")
func _erase_enemy():
	if loaded:
		for i in range(enemies.size()):
			match enemies[i]:
				"enemy":
					print(typeof(characters[i]))
					if is_instance_valid(characters[i]):
						print("erased!")
						if characters[i].get_child_count() > 0:
							if characters[i].get_child(-1, false) != null:
								if characters[i].get_child(-1, false).possess_health > 0:
									characters[i].call_deferred("_erase")
				"save":
					if is_instance_valid(characters[i]):
						characters[i].call_deferred("_erase")
				"treasure":
					if is_instance_valid(characters[i]):
						characters[i].call_deferred("_erase")
		if is_instance_valid(POSSESS_ENEMY):
			print("erased!")
			if POSSESS_ENEMY.get_child_count() > 0:
					if POSSESS_ENEMY.get_child(-1, false) != null:
						if POSSESS_ENEMY.get_child(-1, false).possess_health > 0:
								POSSESS_ENEMY.call_deferred("_erase")
func _possess_enemy_set(enemy):
	POSSESS_ENEMY = enemy
