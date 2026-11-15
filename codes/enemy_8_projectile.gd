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
@onready var attack_player = true
func _ready() -> void:
	parent = get_parent().get_parent()
func _erase():
	queue_free()
func _shoot():
	$Node2D/CharacterBody2D.velocity = target_position.normalized() * -190
func _attack():
	$Node2D/CharacterBody2D.velocity = target_position.normalized() * 80
	await get_tree().create_timer(0.15).timeout
	$Node2D/CharacterBody2D.velocity = target_position.normalized() * 0
	await get_tree().create_timer(0.05).timeout
	_shoot()
func _process(delta: float) -> void:
	if not attack_player:
		$Node2D/CharacterBody2D/Area2D.add_to_group("player_damaging")
		$Node2D/CharacterBody2D/Area2D.remove_from_group("damage")
		$Node2D/CharacterBody2D/RayCast2D.set_collision_mask_value(5, false)
		for i in range(2, 8, 2):
			$Node2D/CharacterBody2D/RayCast2D.set_collision_mask_value(i, true)
	$Node2D/CharacterBody2D.move_and_slide()
	if Input.is_action_just_pressed("9"):
		_fly(Vector2(0, 0))
	if move_start:
		moved_time += 0.1
	if moving:
		move_start = true
		if not $Node2D/CharacterBody2D/RayCast2D.is_colliding():
			$Node2D.rotation_degrees += 5
		if $Node2D/CharacterBody2D/RayCast2D.is_colliding():
			target_position = $Node2D/CharacterBody2D.global_position - $Node2D/CharacterBody2D/RayCast2D.get_collision_point()
			moving = false
			_attack()
	if moved_time > 20:
		call_deferred("_screen_not_visible")
func _screen_not_visible():
	reparent(parent)
	parent.call("_projectile_erase", projectile_number)
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
	parent.call_deferred("_enable_detect_collision")
