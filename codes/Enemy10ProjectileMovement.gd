extends CharacterBody2D
@onready var size_grow: Vector2
@onready var erasable: bool = false
@onready var size_speed: float
func _summoned(initial_size: Vector2, size_growth: Vector2, size_growth_speed: float, direction: float):
	scale = initial_size
	global_rotation_degrees = direction
	size_grow = size_growth
	size_speed = size_growth_speed
func _physics_process(delta: float) -> void:
	move_and_slide()
	scale += size_grow
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
