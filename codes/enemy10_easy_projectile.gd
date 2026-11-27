extends CharacterBody2D
@onready var size_grow: Vector2
@onready var erasable: bool = false
@onready var size_speed: float
@onready var projectile_owner: Node2D
@onready var last_velocity: Vector2
@onready var timer: float = 0 
@onready var projectile_erase: bool = true
func _physics_process(delta: float) -> void:
	timer += 0.1
	if timer > 80:
		timer = 0
		get_parent().queue_free()
	move_and_slide()
func _start(target_position: Vector2):
	velocity = target_position.normalized() * 190
	look_at(to_global(target_position))
