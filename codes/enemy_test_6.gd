extends CharacterBody2D
var direction = -1
var health = 1
var possess_health = 1
var SLIDE
var INVINCIBLE = false
var POSSESSED = false
var TARGET_POS = Vector2i(0, 0)
var HAS_TARGET = 0
var STATUS = {"speed": 0, "jump": -250, "slide": 60, "damage_multiplier": -0.8, "hitbox_y": 15.5, "hitbox_x": 15.5, "air_speed": 70, "damage": 1, "extra_damage": 1}
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _physics_process(_delta: float) -> void:
	move_and_slide()
	if possess_health > 0:
		INVINCIBLE = false
		POSSESSED = false
		$EnemyTestCollision.disabled = false
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
		velocity.y = move_toward(velocity.y, 0, 10)
		if HAS_TARGET == 0:
			velocity.x = direction * STATUS.air_speed
		if HAS_TARGET == 2:
			position.x = move_toward(position.x, TARGET_POS.x, 2)
			position.y = move_toward(position.y, TARGET_POS.y, 2)
			await get_tree().create_timer(0.6).timeout
			HAS_TARGET = 0
	if possess_health == -1:
		$EnemyTestCollision.disabled = true
		INVINCIBLE = true
		POSSESSED = true
		position.x = Autoloads.PLAYER_POSITION_X
		position.y = Autoloads.PLAYER_POSITION_Y
		$EnemyArea/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		if Autoloads.PLAYER_POSSESS_STOP:
			_possess_stop()
func _on_left_collision_check_body_entered(_body: Node2D) -> void:
	direction = 1
	$Sprite2D.flip_h = false
	$RayCast2D.target_position = Vector2(50, 0)
func _on_right_collision_check_body_entered(_body: Node2D) -> void:
	direction = -1
	$Sprite2D.flip_h = true
	$RayCast2D.target_position = Vector2(-50, 0)
func _possess_stop() -> void:
	Autoloads.PLAYER_POSSESS_STOP = false
	possess_health = 1
	velocity.y = -100
	velocity.x = 0
	health = 1
	await get_tree().create_timer(1).timeout
	INVINCIBLE = false
func _process(_delta: float) -> void:
	if not Autoloads.PLAYER_POSSESSING and POSSESSED:
		_possess_stop()
	if Autoloads.POSSESS_AMOUNT > 1:
		_possess_stop()
	if health == 0:
		queue_free()
	if Autoloads.POSSESS_AMOUNT > 1:
		_possess_stop()
	if health < 0:
		queue_free()
	if possess_health == 0:
		Autoloads.POSSESS_AMOUNT += 1
		Autoloads.POSSESS_ABILITY = "TARGET_DASH"
		Autoloads.POSSESS_ENEMY = "FLY_TEST"
		Autoloads.POSSESS_STATUS = STATUS
		possess_health = -1
		Autoloads.POSSESS_SPRITE = "res://assets/placeholder_enemy.png"
		Autoloads.PLAYER_POSSESSING = true
		velocity.x = 0
		velocity.y = 0

func _on_search_area_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if HAS_TARGET == 0:
		velocity.x = 0
		velocity.y = 0
		HAS_TARGET = 1
		if body.position.x - position.x > 0:
			direction = 1
		else:
			direction = -1
		if body.position.x > position.x:
			TARGET_POS.x = body.position.x + 150
		if body.position.x < position.x:
			TARGET_POS.x = body.position.x - 150
		else:
			TARGET_POS.x = 0
		if body.position.y > position.y:
			TARGET_POS.y = body.position.y + 150
		if body.position.x < position.y:
			TARGET_POS.y = body.position.y - 150
		else:
			TARGET_POS.y = 0
		await get_tree().create_timer(0.5).timeout
		HAS_TARGET = 2
		print(TARGET_POS)
func _on_enemy_area_area_entered(area: Area2D) -> void:
	if not INVINCIBLE:
		if area.name == "PlayerProjectile":
			health -= 1
			print("hit!")
		if area.name == "AttackCollision":
			health -= 1
		if area.name == "ExtraAttack":
			health -= 5
		if area.name == "PossessArea":
			possess_health -= 1
			print("hit!")
