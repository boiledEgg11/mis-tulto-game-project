extends RayCast2D
var max_length = Vector2(100, 100)
var speed = 300
var attacking = false
func _ready() -> void:
	pass # Replace with function body.
func _placement(x_pos, y_pos, x_length, y_length):
	position = Vector2i(x_pos, y_pos)
	max_length = Vector2i(x_length, y_length)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _physics_process(delta: float) -> void:
	if attacking:
		print("attacking!")
		target_position.x = move_toward(target_position.x, max_length.x, speed * delta)
		target_position.y = move_toward(target_position.y, max_length.y, speed * delta)
func _attack():
	pass
func _is_attacking():
	if not attacking:
		target_position = Vector2i(0, 0)
	
