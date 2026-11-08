extends RayCast2D
var max_length = Vector2(100, 100)
var speed = 300
var attacking = false
var laser_end_position = Vector2(0, 0)
var laser_move = Vector2(0, -10)
func _ready() -> void:
	$Line2D.set_point_position(0, Vector2(0, -7.5))

func _placement(x_pos, y_pos, x_length, y_length):
	position = Vector2i(x_pos, y_pos)
	max_length = Vector2i(x_length, y_length)
func _process(delta: float) -> void:
	pass
func _physics_process(delta: float) -> void:
	if not is_colliding():
		target_position.x = move_toward(target_position.x, max_length.x, speed * delta)
		target_position.y = move_toward(target_position.y, max_length.y, speed * delta)
		laser_end_position = target_position
	force_raycast_update()
	if is_colliding():
		target_position = laser_end_position
		laser_end_position = to_local(get_collision_point())
	$Line2D.set_point_position(1, laser_end_position)
func _attack():
	pass
