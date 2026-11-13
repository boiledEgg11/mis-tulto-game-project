extends Area2D
var speed = 120
var direction = 1
var MOVING = true
func _process(delta: float) -> void:
	if Autoloads.RESET:
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if MOVING:
		if direction != 0:
			if not $VisibleOnScreenNotifier2D.is_on_screen():
				queue_free()
		position.y+= speed * delta
func _on_body_entered(_body) -> void:
	MOVING = false
	$Sprite2D.texture = load("res://assets/placeholders/placeholder_projectile_explosion.png")
	$CollisionShape2D.shape.radius = 32
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.shape.radius = 8
	queue_free()


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("tile_breakable"):
		var tiles = body.get_coords_for_body_rid(body_rid)
		body.erase_cell(tiles)
