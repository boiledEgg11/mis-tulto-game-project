extends CharacterBody2D
const Speed = 300;
const Jump_velocity = 500;

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = Jump_velocity
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
	
	move_and_slide()
# Called every frame. 'delta' is the elapsed time since the previous frame.s
