extends CharacterBody2D
var SPEED = 50
var direction = -1
var health = 2
var possess_health = 2
var SLIDE
var INVINCIBLE = false
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _physics_process(delta: float) -> void:
	move_and_slide()
	if possess_health > 0:
		if is_on_wall_only():
			direction *= -1
		if not abs(velocity.x) == 50:
			direction *= -1
		if is_on_floor():
			velocity.x = direction * SPEED
			velocity.y = -400
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
		if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
		if direction == 1:
			$Sprite2D.flip_h = false
		if direction == -1:
			$Sprite2D.flip_h = true
	else:
			INVINCIBLE = true
			position.x = Autoloads.PLAYER_POSITION_X
			position.y = Autoloads.PLAYER_POSITION_Y
			$EnemyArea/CollisionShape2D.disabled = true
			$Sprite2D.visible = false
func _possess_stop() -> void:
	Autoloads.PLAYER_POSSESS_STOP = false
	possess_health = 1
	velocity.y = -100
	velocity.x = 0
	health = 1
	await get_tree().create_timer(1).timeout
	INVINCIBLE = false
func _on_left_collision_check_body_entered(body: Node2D) -> void:
	direction = 1
	$Sprite2D.flip_h = false
func _on_right_collision_check_body_entered(body: Node2D) -> void:
	direction = -1
	$Sprite2D.flip_h = true
func _on_enemy_area_area_entered(area) -> void:
	if not INVINCIBLE:
		if area.name == "AttackCollision":
			health -= 1
		if area.name == "PossessArea":
			possess_health -= 1
func _process(delta: float) -> void:
		if Autoloads.PLAYER_POSSESS_STOP and possess_health < 1:
			_possess_stop()
		if health == 0:
			queue_free()
		if possess_health == 0:
			Autoloads.POSSESS_ABILITY = "Jump"
			Autoloads.POSSESS_AMOUNT += 1
			Autoloads.POSSESS_STATUS = {"speed": 75, "jump": -400, "slide": 60, "damage_multiplier": -0.8, "hitbox_y": 16, "hitbox_x": 16}
			possess_health = -1
			Autoloads.POSSESS_SPRITE = "res://assets/placeholder_enemy_bouncy.png"
			Autoloads.PLAYER_POSSESSING = true
			velocity.x = 0
			velocity.y = 0
