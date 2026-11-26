extends CharacterBody2D
@onready var size_grow: Vector2
@onready var erasable: bool = false
@onready var size_speed: float
@onready var projectile_owner: Node2D
@onready var last_velocity: Vector2
func _summoned(initial_size: Vector2, size_growth: Vector2, size_growth_speed: float, target_position: Vector2, parent):
	global_position = parent.global_position
	scale = initial_size
	look_at(to_global(target_position))
	velocity = target_position.normalized() * -190
	last_velocity = target_position.normalized() * 190
	size_grow = size_growth
	size_speed = size_growth_speed
func _z_close_normal():
	scale.x += 0.02
	scale.y += 0.02 * 2
func _z_close_reversing():
	scale.y -= 0.1
	scale.x += 0.02
	velocity.x = move_toward(velocity.x, 0, 15)
	velocity.y = move_toward(velocity.y, 0, 15)
func _z_close_reverse():
	scale.y -= size_grow.y * size_speed * 0.5
	scale.x += 0.02
	velocity.x = move_toward(velocity.x, last_velocity.x, 15)
	velocity.y = move_toward(velocity.y, last_velocity.y, 15)
func _physics_process(delta: float) -> void:
	if scale.x > 0.5 and scale.y > 0:
		_z_close_reversing()
	else:
		if scale.y < 0:
			_z_close_reverse()
		else:
			_z_close_normal()
	move_and_slide()
	if scale.x < 1 and scale.y < 1:
		z_index = -2
	else:
		z_index = 1
	if scale.x > 1 and scale.y > 1:
		if not scale.x > 1.5 or not scale.y > 1.5:
			erasable = true
		else:
			erasable = false
	else:
		erasable = false
	if erasable:
		$Area2D/CollisionShape2D.disabled = false
	else:
		$Area2D/CollisionShape2D.disabled = true
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("background_guard"):
		get_parent().queue_free()
