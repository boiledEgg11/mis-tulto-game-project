extends Area2D
@onready var player_collision = false
@onready var player
func _process(delta: float) -> void:
	if player_collision:
		get_parent().call_deferred("_attack_end")
		player.map_changable = 60
		player.velocity = Vector2(0, 0)
		player.call("_change_map", "test_level_map_4", 1)
		player.velocity = Vector2(0, 0)
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_collision = false
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_collision = true
		player = body
		print("player_colliding!")
