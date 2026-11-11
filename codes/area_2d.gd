extends Area2D
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.call("_change_map", "test_level_map_2", 0)
