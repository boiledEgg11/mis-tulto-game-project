extends CharacterBody2D
var SPEED = 50
var direction = -1
var health = 5
var possess_health = 0
var SLIDE
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _physics_process(delta: float) -> void:
	move_and_slide()
	if possess_health != -1:
		if possess_health > health:
			possess_health = health
		velocity.x = direction * SPEED
		if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
	else:
		if possess_health == -1:
			SPEED = 120
			$EnemyArea/CollisionShape2D.disabled = true
			move_and_slide()
			direction = Input.get_axis("left", "right")
			if direction > 0:
				$Sprite2D.flip_h = false
			if direction < 0:
				$Sprite2D.flip_h = true
			if not is_on_floor():
				SLIDE = 5
			else:
				SLIDE = 30
			if not is_on_floor():
				if Input.is_action_pressed("down"):
					velocity += get_gravity() * delta * 2.5
				else:
					velocity += get_gravity() * delta * 1.5
		if is_on_floor():
			if Input.is_action_just_pressed("up"):
				velocity.y = -400
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
			if direction:
					velocity.x = SPEED * direction
			if not direction:
				velocity.x = move_toward(velocity.x, 0, SLIDE)
				direction = 0

func _on_left_collision_check_body_entered(body: Node2D) -> void:
	direction = 1
	$Sprite2D.flip_h = true
func _on_right_collision_check_body_entered(body: Node2D) -> void:
	direction = -1
	$Sprite2D.flip_h = false
func _on_enemy_area_area_entered(area) -> void:
	if area.name == "AttackCollision":
		health -= 1
		print("damaged")
	if area.name == "PossessArea":
		possess_health -= 1
func _process(delta: float) -> void:
	if health == 0:
		queue_free()
	if possess_health == 0:
		position.x = Autoloads.PLAYER_POSITION_X
		position.y = Autoloads.PLAYER_POSITION_Y
		possess_health = -1
		velocity.x = 0
		velocity.y = 0
