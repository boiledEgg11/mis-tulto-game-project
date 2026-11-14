extends Node2D
@onready var projectile_number: int
@onready var location
@onready var parent
@onready var released = false
@onready var target_pos: Vector2
@onready var moving = false
@onready var target_touched = false
@onready var rotated = 0
@onready var target_position: Vector2
@onready var moved_time: float
@onready var move_start = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
func _erase():
	queue_free()
func _process(delta: float) -> void:
	$Node2D/CharacterBody2D.move_and_slide()
	if Input.is_action_just_pressed("9"):
		_fly(Vector2(0, 0))
	if target_touched:
		$Node2D/CharacterBody2D.velocity = target_position.normalized() * -180
	if move_start:
		moved_time += 0.1
	if moving:
		move_start = true
		if not $Node2D/CharacterBody2D/RayCast2D.is_colliding():
			$Node2D.rotation_degrees += 5
		if $Node2D/CharacterBody2D/RayCast2D.is_colliding():
			target_position = $Node2D/CharacterBody2D.global_position - $Node2D/CharacterBody2D/RayCast2D.get_collision_point()
			moving = false
			print("touched!")
			target_touched = true
	if moved_time > 20:
			_screen_not_visible()
func _screen_not_visible():
	reparent(parent)
	print("removal")
	get_parent().get_parent().call("_projectile_erase", projectile_number)
func _fly(target: Vector2):
	if not (moving or move_start or target_touched):
		moving = true
		location = global_position
		position = Vector2(0, 0)
		rotated = global_rotation
		released  = true
		call_deferred("reparent", Autoloads.center)
		rotation = rotated
		global_position = location
		target_pos = target
func _detect_collision_close():
	get_parent().get_parent().call_deferred("_disable_detect_collision")
