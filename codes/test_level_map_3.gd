extends Node2D
@onready var puzzle_amount = 0
@onready var attacking = false
@onready var cooldown = 0.0
@onready var player: Node2D
@onready var projectile: Array = [0,0,0,0,0,0,0]
func _erase():
	queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if i is TileMapLayer:
			Autoloads.tiles.append(i)

func _puzzle_solved():
	puzzle_amount += 1
	if puzzle_amount == 2:
		for i in range(-33, -30):
			$TileMapLayer2.erase_cell(Vector2i(i, 5))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if attacking and cooldown > 1:
		cooldown = 0
		_attack()
	if attacking:
		cooldown += 0.1
func _attack():
	print("attack")
	for i in range(0, 6):
		if typeof(projectile[i]) != TYPE_INT:
			if is_instance_valid(projectile[i]):
				print("none")
				return
			else:
				print("replaced")
				projectile[i] = preload("res://scenes/projectile/enemy8_projectile.tscn").instantiate()
				add_child(projectile[i])
				for l in i:
					projectile[l].global_position += Vector2(10, 0)
				projectile[i].global_position = player.position + Vector2(-25, -70)
				projectile[i].call_deferred("_level_summon", player)
		else:
			print("added")
			projectile[i] = preload("res://scenes/projectile/enemy8_projectile.tscn").instantiate()
			add_child(projectile[i])
			for l in i:
				projectile[l].global_position += Vector2(10, 0)
			projectile[i].global_position = player.position + Vector2(-25, -70)
			projectile[i].call_deferred("_level_summon", player)
func _on_attack_start_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		attacking = true


func _on_attack_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		attacking = false
		player = body
