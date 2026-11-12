extends CharacterBody2D
var direction = -1
var health = 1
var possess_health = 1
var SLIDE
var charge = 0
var CHARGING = false
var initial_y = 0
var WAIT = 0
var START = false
var individual
var INVINCIBLE = false
var POSSESSED = false
var STATUS = {"speed": 30, "jump": -300, "slide": 40, "damage_multiplier": -0.8, "hitbox_y": 15.5, "hitbox_x": 15.5, "air_speed": 120, "damage": 1, "extra_damage": 1}
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _charging():
	await get_tree().create_timer(1).timeout
	CHARGING = false
	if possess_health > 0:
		var SHOOT_BULLET = preload("res://scenes/enemy_projectile.tscn").instantiate()
		owner.add_child(SHOOT_BULLET)
		SHOOT_BULLET.position = position
func _physics_process(delta: float) -> void:
	if START:
		match individual:
			1:
				position = Vector2(300, 0)
			_:
				position = Vector2i(300, 0)
		initial_y = position.y
		START = false
	move_and_slide()
	if possess_health > 0:
		var standing = $groundchecker.get_collider()
		if standing:
			if standing.is_in_group("moving_tile") and Autoloads.is_moving:
				position.x += Autoloads.tile_move
			if standing.is_in_group("moving_tile_y") and Autoloads.is_moving:
				@warning_ignore("integer_division")
				position.y -= Autoloads.tile_move / 2
		if position.y > 175:
			queue_free()
		$EnemyTestCollision.disabled = false
		if $RayCast2D.is_colliding():
			if not CHARGING:
				_charging()
			CHARGING = true
		POSSESSED = false
		if is_on_floor():
			velocity.y = STATUS.jump
		if not is_on_floor():
			if position.y > initial_y:
				velocity.y = STATUS.jump / 4
			if CHARGING:
				velocity.x = direction * STATUS.air_speed / 4
			else:
				velocity.x = direction * STATUS.air_speed
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
		if not is_on_floor():
				velocity += get_gravity() * delta / 5
	if possess_health == -1:
			position = Vector2i(0, 0)
			Autoloads.POSSESS_TYPE = "charge"
			$EnemyTestCollision.disabled = true
			INVINCIBLE = true
			POSSESSED = true
			position.x = Autoloads.PLAYER_POSITION_X
			position.y = Autoloads.PLAYER_POSITION_Y
			$EnemyArea/CollisionShape2D.disabled = true
			$Sprite2D.visible = false
			if Autoloads.PLAYER_POSSESS_STOP:
				print("released!")
				_possess_stop()
func _on_left_collision_check_body_entered(_body: Node2D) -> void:
	direction = 1
	$Sprite2D.flip_h = false
func _on_right_collision_check_body_entered(_body: Node2D) -> void:
	direction = -1
	$Sprite2D.flip_h = true
func _on_enemy_area_area_entered(area) -> void:
	if not INVINCIBLE:
		if area.is_in_group("player_damaging"):
			health -= 1
		if area.name == "PlayerProjectile":
			health -= 1
		if area.name == "AttackCollision":
			health -= 1
		if area.name == "ExtraAttack":
			health -= 5
		if area.name == "PossessArea":
			possess_health -= 1
func _possess_stop() -> void:
	print("freed")
	Autoloads.PLAYER_POSSESS_STOP = false
	possess_health = 1
	velocity.y = -100
	velocity.x = 0
	health = 1
	initial_y = position.y
	await get_tree().create_timer(1).timeout
	INVINCIBLE = false
func _process(_delta: float) -> void:
	if direction == 1:
		$Sprite2D.flip_h = false
	if direction == -1:
		$Sprite2D.flip_h = true
	if not Autoloads.PLAYER_POSSESSING and POSSESSED and possess_health == -1:
		_possess_stop()
		print("1")
	if Autoloads.POSSESS_AMOUNT > 1:
		_possess_stop()
		print("2")
	if health <= 0:
		queue_free()
	if possess_health == 0:
		Autoloads.POSSESS_TARGET = {"species": "TestEnemy4", "individual": individual}
		Autoloads.POSSESS_AMOUNT += 1
		Autoloads.POSSESS_ABILITY = "SHOOT"
		Autoloads.POSSESS_ENEMY = "SHOOT"
		Autoloads.POSSESS_STATUS = STATUS
		Autoloads.POSSESS_SPRITE = "res://assets/placeholders/placeholder/enemy_shoot.png"
		Autoloads.PLAYER_POSSESSING = true
		velocity.x = 0
		velocity.y = 0
		await get_tree().process_frame
		possess_health = -1
func _possess_start():
		Autoloads.POSSESS_TARGET = {"species": "TestEnemy4", "individual": individual}
		Autoloads.POSSESS_AMOUNT += 1
		Autoloads.POSSESS_ABILITY = "SHOOT"
		Autoloads.POSSESS_ENEMY = "SHOOT"
		Autoloads.POSSESS_STATUS = STATUS
		possess_health = -1
		Autoloads.POSSESS_SPRITE = "res://assets/placeholders/placeholder/enemy_shoot.png"
		Autoloads.PLAYER_POSSESSING = true
		velocity.x = 0
		velocity.y = 0
