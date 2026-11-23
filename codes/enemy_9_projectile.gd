extends CharacterBody2D
@onready var direction: int = 1
@onready var remain_time: float = 3
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity.x = direction * 80
	remain_time -= 0.1
	if remain_time <= 0:
		queue_free()
