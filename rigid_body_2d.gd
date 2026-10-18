extends CharacterBody2D
var SPEED = 50
var direction = -1
func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity.x = direction * SPEED
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.5


func _on_left_collision_check_body_entered(body: Node2D) -> void:
	direction = 1
func _on_right_collision_check_body_entered(body: Node2D) -> void:
	direction = -1
