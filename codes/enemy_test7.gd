extends CharacterBody2D
var direction = -1
var health = 1
var possess_health = 1
var SLIDE
var INVINCIBLE = false
var POSSESSED = false
var START = false
var individual
var WALL_EXISTED = false
var CHARGE = 0
var CHARGE_LOCK = false
var CHARGE_LOW = false
var LAZER_DURATION = 120
var STATUS = {"speed": 60, "jump": -250, "slide": 60, "damage_multiplier": -0.8, "hitbox_y": 15.5, "hitbox_x": 15.5, "air_speed": 100, "damage": 1, "extra_damage": 1}
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _attack():
	LAZER_DURATION = 120
	CHARGE_LOCK = true
	$Enemy7Laser.attacking = true
	CHARGE_LOW = true
func _physics_process(delta: float) -> void:
	if START:
		match individual:
			1:
				print("placed")
				position = Vector2i(1016, -56)
				$Enemy7Laser._placement(0, 0, 0, -200)
			_:
				print("none")
				position = Vector2i(0, 0)
		START = false
	move_and_slide()
	if possess_health > 0:
		$Enemy7Laser/Line2D._attack_change(true)
		if not CHARGE_LOCK:
			CHARGE += 1
		if CHARGE > 180:
			CHARGE = 0
			print("attack!")
			_attack()
		var standing = $GroundExistingChecker.get_overlapping_bodies()
		for body in standing:
			if body.is_in_group("moving_tile") and Autoloads.is_moving:
				position.x += Autoloads.tile_move
			if body.is_in_group("moving_tile_y") and Autoloads.is_moving:
				@warning_ignore("integer_division")
				position.y -= Autoloads.tile_move / 2
		if position.y > 175:
			queue_free()
		POSSESSED = false
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
		if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
	if possess_health == -1:
			if not Autoloads.PLAYER_ATTACK:
				_attack_end()
			$Enemy7Laser/Line2D._attack_change(false)
			INVINCIBLE = true
			POSSESSED = true
			Autoloads.PLAYER_POSITION_X = position.x
			Autoloads.PLAYER_POSITION_Y = position.y
			$EnemyArea/CollisionShape2D.disabled = true
			$Sprite2D.visible = false
			if Autoloads.PLAYER_POSSESS_STOP:
				_possess_stop()
func _on_left_collision_check_body_entered(_body: Node2D) -> void:
	if $LeftCollisionCheck.area_entered:
		if individual == 2 and is_on_floor():
			velocity.y = -250
			position.x -= 6 * direction
		else:
			direction *= -1
func _on_enemy_area_area_entered(area) -> void:
	if not INVINCIBLE:
		if area.is_in_group("player_damaging"):
			health -= 1
		if area.name == "PlayerProjectile":
			health -= 1
			print("hit!")
		if area.name == "AttackCollision":
			health -= 1
		if area.name == "ExtraAttack":
			health -= 5
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
func _attack_end():
	CHARGE_LOW = false
	CHARGE_LOCK = false
	$Enemy7Laser.attacking = false
	CHARGE = 0
func _process(_delta: float) -> void:
	if CHARGE_LOW:
		print(LAZER_DURATION)
		LAZER_DURATION -= 1
		if LAZER_DURATION < 0:
			_attack_end()
	$LeftCollisionCheck.position.x = 8 * direction
	$GroundExistingChecker.position.x = 9 * direction
	if direction == 1:
		$Sprite2D.flip_h = false
	if direction == -1:
		$Sprite2D.flip_h = true
	if not Autoloads.PLAYER_POSSESSING and POSSESSED:
		_possess_stop()
	if Autoloads.POSSESS_AMOUNT > 1:
		_possess_stop()
	if Autoloads.POSSESS_AMOUNT > 1:
		_possess_stop()
	if health <= 0:
		queue_free()
	if possess_health == 0:
		CHARGE_LOW = false
		CHARGE_LOCK = false
		$Enemy7Laser.attacking = false
		CHARGE = 0
		Autoloads.POSSESS_ENEMY = get_child(-1)
		Autoloads.POSSESS_TARGET = {"species": "TestEnemy7", "individual": individual}
		Autoloads.POSSESS_AMOUNT += 1
		Autoloads.POSSESS_TYPE = "charge"
		Autoloads.POSSESS_ABILITY = "LASER"
		Autoloads.POSSESS_STATUS = STATUS
		possess_health = -1
		Autoloads.POSSESS_SPRITE = "res://assets/placeholder_enemy.png"
		Autoloads.PLAYER_POSSESSING = true
		velocity.x = 0
		velocity.y = 0


func _on_ground_existing_checker_body_exited(body: Node2D) -> void:
	if body.is_in_group("tile"):
		direction *= -1
