extends Area2D
var light_hit = false
var light_time = 0

# Called when the node enters the scene tree for the first time.
@onready var tile_move_value = Vector2(0, 1.5)
@onready var initial_pos
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pos = position


# Called every frame. 'delta' is the elapsed time since the previous frame
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if light_hit:
		light_time += 1
	else:
		light_time -= 1
	if light_time > 120:
		$Sprite2D.texture = load("res://assets/sprites/bright_light_sprite.png")
		get_parent().call("_puzzle_solved")
	position += tile_move_value
	if position.y < initial_pos.y - 64:
		tile_move_value.y = 1.5
	if position.y > initial_pos.y + 64:
		tile_move_value.y = -1.5


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy7"):
		light_hit = true
		if light_time <= 120:
			$Sprite2D.texture = load("res://assets/sprites/brightened_light_sprite.png")
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy7"):
		light_hit = false
		if light_time <= 120:
			$Sprite2D.texture = load("res://assets/sprites/dim_light_sprite.png")
