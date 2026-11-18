extends Node2D
@onready var puzzle_amount = 0
@onready var attacking = false
@onready var cooldown = 0.0
@onready var player: Node2D
@onready var projectile: Array = [0,0,0,0,0,0,0]
@onready var next_projectile:int = 0
@onready var horizontal_projectile: Array = [0, 0, 0, 0, 0, 0]
@onready var next_h_projectile: int = 0
@onready var rng = RandomNumberGenerator.new()
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
	if attacking and cooldown > 4:
		cooldown = 0
		_attack()
	if attacking:
		cooldown += 0.1
		$Node2D.global_position = player.global_position
func _quick_attck():
	horizontal_projectile[next_h_projectile] = preload("res://scenes/projectile/enemy8_projectile.tscn").instantiate()
	add_child(horizontal_projectile[next_h_projectile])
	horizontal_projectile[next_h_projectile] = player.global_position
func _attack():
	var random_value = rng.randf_range(-85, 85)
	var random_result =sqrt(abs(random_value * random_value * -1 + 7225))
	print(Vector2(random_value, random_result))
	projectile[next_projectile] = preload("res://scenes/projectile/enemy8_projectile.tscn").instantiate()
	add_child(projectile[next_projectile])
	projectile[next_projectile].global_position = player.global_position - Vector2(random_result * -1, random_value)
	projectile[next_projectile].call_deferred("_level_summon", $Node2D)
	if next_projectile == 6:
		next_projectile = 0
	else:
		next_projectile += 1

func _on_attack_start_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		attacking = true
func _attack_end():
	attacking = false

func _on_attack_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		attacking = false
		player = body
