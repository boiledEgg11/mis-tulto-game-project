extends Node2D
func _summon(direction_projectile, possess_health):
	if direction_projectile == -1:
		$CharacterBody2D/Sprite2D.flip_h = false
	else:
		$CharacterBody2D/Sprite2D.flip_h = true
	if possess_health < 0:
		$CharacterBody2D/Area2D.remove_from_group("damage")
		$CharacterBody2D/Area2D.add_to_group("player_damaging")
	$CharacterBody2D.direction = direction_projectile
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
