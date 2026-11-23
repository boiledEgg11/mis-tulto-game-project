extends CharacterBody2D
@onready var direction: int = 1
@onready var added_speed: float
@onready var remain_time: float = 9
func _ready() -> void:
	pass # Replace with function body.
func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity.x = direction * 40 + added_speed
	remain_time -= 0.1
	if remain_time <= 0:
		queue_free()
