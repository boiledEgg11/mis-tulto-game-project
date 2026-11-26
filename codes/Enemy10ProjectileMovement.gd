extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _summoned(initial_size: Vector2, size_growth: float, direction: float):
	scale = initial_size
func _physics_process(delta: float) -> void:
	move_and_slide()
