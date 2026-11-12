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
var projectile_amount = 0
var projectile: Array = [preload("res://scenes/empty.tscn").instantiate(), preload("res://scenes/empty.tscn").instantiate(), preload("res://scenes/empty.tscn").instantiate(), preload("res://scenes/empty.tscn").instantiate(), preload("res://scenes/empty.tscn").instantiate()]
var STATUS = {"speed": 60, "jump": -250, "slide": 60, "damage_multiplier": -0.8, "hitbox_y": 15.5, "hitbox_x": 15.5, "air_speed": 100, "damage": 1, "extra_damage": 1}
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _summon_projectile(summon_amount):
	for i in range(summon_amount):
		projectile[i].queue_free()
		projectile_amount += 1
		projectile[i] = preload("res://scenes/enemy8_projectile.tscn").instantiate()
		$SpinManager.add_child(projectile[i])
		projectile[i].get_child(0).position = Vector2i(0, -50)
		for l in range(0, i):
			projectile[l].rotation_degrees += 72
func _physics_process(delta: float) -> void:
	if START:
		match individual:
			1:
				position = Vector2(0, 0)
				print("none")
				position = Vector2i(0, 0)
		START = false
	move_and_slide()
	if possess_health > 0:
		if projectile_amount < 5:
			_summon_projectile(5 - projectile_amount)
		var standing = $groundchecker.get_collider()
		if standing:
			if standing.is_in_group("moving_tile") and Autoloads.is_moving:
				position.x += Autoloads.tile_move
			if standing.is_in_group("moving_tile_y") and Autoloads.is_moving:
				@warning_ignore("integer_division")
				position.y -= Autoloads.tile_move / 2
		if position.y > 175:
			queue_free()
		POSSESSED = false
		velocity.x = direction * STATUS.speed
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
		if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
	if possess_health == -1:
			INVINCIBLE = true
			POSSESSED = true
			position.x = Autoloads.PLAYER_POSITION_X
			position.y = Autoloads.PLAYER_POSITION_Y
			$EnemyArea/CollisionShape2D.disabled = true
			$Sprite2D.visible = false
			if Autoloads.PLAYER_POSSESS_STOP:
				_possess_stop()
func _on_left_collision_check_body_entered(_body: Node2D) -> void:
	if $LeftCollisionCheck.area_entered:
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
func _process(_delta: float) -> void:
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
		Autoloads.POSSESS_TARGET = {"species": "TestEnemy1", "individual": individual}
		Autoloads.POSSESS_AMOUNT += 1
		Autoloads.POSSESS_ABILITY = "None"
		Autoloads.POSSESS_ENEMY = "TEST"
		Autoloads.POSSESS_STATUS = STATUS
		possess_health = -1
		Autoloads.POSSESS_SPRITE = "res://assets/placeholder_enemy.png"
		Autoloads.PLAYER_POSSESSING = true
		velocity.x = 0
		velocity.y = 0


func _on_ground_existing_checker_body_exited(body: Node2D) -> void:
	if individual == 3:
		if body.is_in_group("tile"):
			direction *= -1
