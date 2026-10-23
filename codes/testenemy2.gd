extends CharacterBody2D
var direction = -1
var health = 1
var possess_health = 0
var SLIDE
var POSSESSED = false
var INVINCIBLE = false
var JUMP_CHARGE = 0
var STATUS = {"speed": 80, "jump": -300, "slide": 60, "damage_multiplier": -0.8, "hitbox_y": 15.5, "hitbox_x": 15.5, "air_speed":100}
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _physics_process(delta: float) -> void:
	move_and_slide()
	if possess_health > 0:
		POSSESSED = false
		if is_on_wall_only():
			direction *= -1
		if not is_on_floor():
			velocity.x = direction * STATUS.air_speed
		if is_on_floor():
			JUMP_CHARGE += 1
			velocity.x = 0
			if JUMP_CHARGE > 30:
				JUMP_CHARGE = 0
				velocity.y = STATUS.jump
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
		if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
		if velocity.x > 0:
			$Sprite2D.flip_h = false
		if velocity.x < 0:
			$Sprite2D.flip_h = true
	if possess_health == -1:
			INVINCIBLE = true
			POSSESSED = true
			position.x = Autoloads.PLAYER_POSITION_X
			position.y = Autoloads.PLAYER_POSITION_Y
			$EnemyArea/CollisionShape2D.disabled = true
			$Sprite2D.visible = false
func _on_left_collision_check_body_entered(body: Node2D) -> void:
	direction = 1
func _on_right_collision_check_body_entered(body: Node2D) -> void:
	direction = -1
func _on_enemy_area_area_entered(area) -> void:
	if not INVINCIBLE:
		if area.name == "AttackCollision":
			health -= 1
		if area.name == "PossessArea":
			possess_health -= 1
func _possess_stop() -> void:
	Autoloads.PLAYER_POSSESS_STOP = false
	possess_health = 1
	velocity.y = -100
	velocity.x = 0
	health = 1
	await get_tree().create_timer(1).timeout
	INVINCIBLE = false
func _process(delta: float) -> void:
	if not Autoloads.PLAYER_POSSESSING and POSSESSED:
		_possess_stop()
	if $Sprite2D.visible == false:
		print("invis")
	if Autoloads.POSSESS_AMOUNT > 1:
		_possess_stop()
	if health == 0:
		queue_free()
	if Autoloads.POSSESS_AMOUNT > 1:
		_possess_stop()
	if health == 0:
		queue_free()
	if possess_health == 0:
		Autoloads.PLAYER_POSSESSING = true
		Autoloads.POSSESS_ABILITY = "Jump"
		Autoloads.POSSESS_ENEMY = "frog"
		Autoloads.POSSESS_AMOUNT += 1
		Autoloads.POSSESS_STATUS = STATUS
		possess_health = -1
		Autoloads.POSSESS_SPRITE = "res://assets/placeholder_enemy_bouncy.png"
		velocity.x = 0
		velocity.y = 0
