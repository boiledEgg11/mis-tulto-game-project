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


func _on_erase_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("background_guard") and projectile_erase:
		get_parent().queue_free()
