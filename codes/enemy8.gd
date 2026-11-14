extends CharacterBody2D
@onready var player
@onready var projectile_cooldown = 0
@onready var direction = -1
@onready var health = 1
@onready var possess_health = 1
@onready var SLIDE
@onready var ground_exist = true
@onready var forced_direction = false
@onready var INVINCIBLE = false
@onready var POSSESSED = false
@onready var START = false
@onready var individual
@onready var projectile_released = false
@onready var WALL_EXISTED = false
@onready var projectile_amount = 0
@onready var projectile_exists: Array = [false, false, false, false, false]
@onready var projectile: Array = [preload("res://scenes/empty.tscn").instantiate(), preload("res://scenes/empty.tscn").instantiate(), preload("res://scenes/empty.tscn").instantiate(), preload("res://scenes/empty.tscn").instantiate(), preload("res://scenes/empty.tscn").instantiate()]
@onready var STATUS = {"speed": 60, "jump": -250, "slide": 60, "damage_multiplier": -0.8, "hitbox_y": 15.5, "hitbox_x": 15.5, "air_speed": 100, "damage": 1, "extra_damage": 1}
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _summon_projectile(summon_amount):
	for i in range(summon_amount):
		if not projectile_exists[i]:
			projectile_amount += 1
			projectile[i].queue_free()
			projectile[i] = preload("res://scenes/enemy8_projectile.tscn").instantiate()
			projectile_exists[i] = true
			projectile[i].projectile_number = i
			$SpinManager.add_child(projectile[i])
			projectile[i].get_child(0).scale = Vector2(0.5, 0.5)
			projectile[i].get_child(0).position = Vector2(0, 0)
			for l in range(0, i):
				projectile[l].rotation_degrees += 360 / summon_amount
	await get_tree().create_timer(0.2).timeout
	projectile_released = true
	_enable_detect_collision()
func _projectile_erase(projectile_number):
	projectile[projectile_number].call("_erase")
	projectile[projectile_number]  = preload("res://scenes/empty.tscn").instantiate()
	projectile_exists[projectile_number] = false
	projectile_amount -= 1
	print(projectile_amount)
func _disable_collision_shape():
	$DetectionArea/CollisionShape2D.disabled = true
func _call_fly():
	call_deferred("_disable_collision_shape")
	projectile_cooldown = 0
	for child_projectile in $SpinManager.get_children(true):
		child_projectile.call("_fly", Vector2(0, 0))
func _physics_process(delta: float) -> void:
	for i in range(3):
		if projectile[i].get_child(0).scale < Vector2(1, 1):
			projectile[i].get_child(0).scale += Vector2(0.05, 0.05)
		if projectile[i].get_child(0).position.y > -50:
			projectile[i].get_child(0).position.y -= 2
	if player:
		if $DetectionArea.overlaps_body(player):
			_call_fly()
	if START:
		match individual:
			1:
				position = Vector2(0, 0)
				position = Vector2i(0, 0)
		START = false
	move_and_slide()
	if possess_health > 0:
		if not ground_exist:
			forced_direction = true
			direction *= -1
			ground_exist = true
			_forced_direction_fix()
		if projectile_amount < 3:
			_summon_projectile(3)
		$SpinManager.rotation_degrees += 1
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
		if not forced_direction:
			if player and $DetectionArea/CollisionShape2D:
				if player.position.x > position.x:
					direction = -1
				if player.position.x < position.x:
					direction = 1
			if not $DetectionArea/CollisionShape2D.disabled and player:
				if player.position.x > position.x:
					direction = 1
				if player.position.x < position.x:
					direction = -1
		$EnemyArea/CollisionShape2D.disabled = false
		velocity.x = direction * STATUS.speed
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
		Autoloads.POSSESS_SPRITE = "res://assets/placeholders/placeholder_enemy.png"
		Autoloads.PLAYER_POSSESSING = true
		velocity.x = 0
		velocity.y = 0
func _forced_direction_fix():
	await get_tree().create_timer(0.5).timeout
	forced_direction = false

func _on_ground_existing_checker_body_exited(body: Node2D) -> void:
	if body.is_in_group("tile"):
		ground_exist = false

func _on_detection_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		_call_fly()
		player = body
func _enable_detect_collision():
	$DetectionArea/CollisionShape2D.disabled = false


func _on_ground_existing_checker_body_entered(body: Node2D) -> void:
	if body.is_in_group("tile"):
		ground_exist = true
