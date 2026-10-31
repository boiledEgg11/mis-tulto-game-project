extends CharacterBody2D
var direction = -1
var health = 1
var possess_health = 1
var SLIDE
var INVINCIBLE = false
var POSSESSED = false
var attacking = false
var charge = 0
var ATTACK = false
var STATUS = {"speed": 85, "jump": -350, "slide": 60, "damage_multiplier": -0.8, "hitbox_y": 15.5, "hitbox_x": 15.5, "air_speed": 100}
func _ready() -> void:
	$Area2D/Sprite2D.visible = false
	$EnemyArea/CollisionShape2D.disabled = false
func _attack_charge():
	charge = 1
	await get_tree().create_timer(0.25).timeout
	$Sprite2D.texture = load("res://assets/placeholder_enemy_explosive_charge.png")
	await get_tree().create_timer(0.25).timeout
	$Sprite2D.texture = load("res://assets/placeholder_enemy_explosion.png")
	await get_tree().create_timer(0.25).timeout
	$Sprite2D.texture = load("res://assets/placeholder_enemy_explosive_charge.png")
	await get_tree().create_timer(0.25).timeout
	$Sprite2D.texture = load("res://assets/placeholder_enemy_explosion.png")
	await get_tree().create_timer(0.25).timeout
	$Sprite2D.texture = load("res://assets/placeholder_enemy_explosive_charge.png")
	await get_tree().create_timer(0.25).timeout
	$Sprite2D.texture = load("res://assets/placeholder_enemy_explosion.png")
	await get_tree().create_timer(0.25).timeout
	$Sprite2D.texture = load("res://assets/placeholder_enemy_explosive_charge.png")
	await get_tree().create_timer(0.25).timeout
	$Sprite2D.texture = load("res://assets/placeholder_enemy_explosion.png")
	if possess_health > 0:
		$Area2D.position = Vector2i(10 * direction, 0)
		$Area2D/CollisionShape2D.disabled = false
		$Area2D/Sprite2D.visible = true
		await get_tree().create_timer(0.1).timeout
		$Area2D/CollisionShape2D.disabled = true
		$Area2D/Sprite2D.visible = false
	charge = 0
	attacking = false
	direction *= -1
func _physics_process(delta: float) -> void:
	move_and_slide()
	if possess_health > 0:
		POSSESSED = false
		if $player_detection.is_colliding():
			attacking = true
		if $RayCast2D.is_colliding():
			direction *= -1
		if direction == 1:
			$player_detection.rotation_degrees = 0 
			$player_detection.position = Vector2i(10, 0)
			$Sprite2D.flip_h = false
			$RayCast2D.rotation_degrees = 180
			$RayCast2D.position = Vector2i(-10, 0)
		if direction == -1:
			$player_detection.rotation_degrees = 180 
			$player_detection.position = Vector2i(-10, 0)
			$Sprite2D.flip_h = true
			$RayCast2D.rotation_degrees = 0
			$RayCast2D.position = Vector2i(10, 0)
		if not attacking:
			velocity.x = direction * STATUS.speed
		if attacking:
			velocity.x = direction * STATUS.speed / 4
			if charge == 0:
				_attack_charge()
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
		if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
	if possess_health == -1:
		$Area2D/CollisionShape2D.disabled = true
		INVINCIBLE = true
		POSSESSED = true
		position.x = Autoloads.PLAYER_POSITION_X
		position.y = Autoloads.PLAYER_POSITION_Y
		$EnemyArea/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		if Autoloads.PLAYER_POSSESS_STOP:
			_possess_stop()
func _on_left_collision_check_body_entered(_body: Node2D) -> void:
	if not attacking:
		direction = 1

func _on_right_collision_check_body_entered(_body: Node2D) -> void:
	if not attacking:
		direction = -1
func _on_enemy_area_area_entered(area) -> void:
	if not INVINCIBLE:
		if area.name == "PlayerProjectile":
			health -= 1
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
	if direction == 1:
		$player_detection.rotation_degrees = 0 
		$player_detection.position = Vector2i(10, 0)
		$Sprite2D.flip_h = false
		$RayCast2D.rotation_degrees = 180
		$RayCast2D.position = Vector2i(-10, 0)
	if direction == -1:
		$player_detection.rotation_degrees = 180 
		$player_detection.position = Vector2i(-10, 0)
		$Sprite2D.flip_h = true
		$RayCast2D.rotation_degrees = 0
		$RayCast2D.position = Vector2i(10, 0)
	if not Autoloads.PLAYER_POSSESSING and POSSESSED:
		_possess_stop()
	if Autoloads.POSSESS_AMOUNT > 1:
		_possess_stop()
	if health == 0:
		queue_free()
	if health < 0:
		queue_free()
	if possess_health == 0:
		Autoloads.POSSESS_AMOUNT += 1
		Autoloads.POSSESS_ABILITY = "EXPLOSIVE"
		Autoloads.POSSESS_ENEMY = "EXPLOSIVE_ENEMY"
		Autoloads.POSSESS_STATUS = STATUS
		possess_health = -1
		Autoloads.POSSESS_SPRITE = "res://assets/placeholder_enemy_explosion.png"
		Autoloads.PLAYER_POSSESSING = true
		velocity.x = 0
		velocity.y = 0
