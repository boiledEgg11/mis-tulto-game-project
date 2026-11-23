extends CharacterBody2D
@onready var direction: int = 1
@onready var added_speed: float
@onready var remain_time: float = 3
func _ready() -> void:
	pass # Replace with function body.
func _physics_process(delta: float) -> void:
	move_and_slide()
	print(added_speed)
	velocity.x = direction * 80 + added_speed
	remain_time -= 0.1
	if remain_time <= 0:
		queue_free()
