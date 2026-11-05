extends CharacterBody2D
var DASHING = false
var direction = 1
var health = 10
var ENEMY_COLLISION = false
var DASH_Y_CHANGE = 0
var CROUCH = false
var DASH_DIRECTION = 0
var DASH_MOVE = false
var POSSESS_END = false
var ANIMATION_MOVED = false
var CROUCH_BLOCK = false
var INVINCIBLE = false
var INVINCIBLE_HOLD = false
var STATUS = {"speed": 120, "jump": -400, "damage_multiplier": -1, "slide": 0, "hitbox_x": 15.5, "hitbox_y": 15.5, "air_speed": 120, "damage": 1, "extra_damage": 1}
var TEXTURE_LOCK
var CHARGE = 0
var ABILITY_USE = true
var bodies
var SAVABLE = false
var SAVE_THINGS
var DASH_LOCK = false
var MOVE_LOCK = false
var ABILITY_LOCK = false
var SPEED_MULTIPLIER = 1
var POSSESS_START = true
var TARGET_POS = Vector2(0, 0)
var ATTACK_COLLISION = false
var HAS_TARGET = 0
var OVERLAPPING_SAVE = "none"
var SAVE = preload("res://scenes/save.tscn")
func _ready() -> void:
	$Camera2D/Control/BoxContainer/TextureButton.visible = false
	$ExtraAttack/Sprite2D.visible = false
	$CrouchTestArea/CollisionShape2D.shape.size = Vector2(15.5, 15.5)
	$Camera2D/PlayerHealth.value = 10
	$AttackCollision/CollisionShape2D.disabled = true
	$PossessArea/PossessShape.disabled = true
	$DamageCollision/PlayerDamageCollision.disabled = false
	$DamageCollision/PlayerDamageCollision.shape.size = Vector2(15, 15)
func _dash_hold_stop():
	await get_tree().create_timer(0.05).timeout
	if is_on_floor():
		ATTACK_COLLISION = false
		INVINCIBLE_HOLD = false
		DASH_LOCK = false
		INVINCIBLE = false
		$AnimatedSprite2D.visible = true
		$Sprite2D.visible = false
func _health_process(DAMAGE) -> void:
	if not INVINCIBLE:
		TEXTURE_LOCK = true
		if DAMAGE > 0:
			if not Autoloads.PLAYER_POSSESSING:
				$AnimatedSprite2D.play("hurt")
			$Camera2D/PlayerHealth.value += DAMAGE * STATUS.damage_multiplier
		if $Camera2D/PlayerHealth.value <= 0:
			_death()
		INVINCIBLE = true
		await get_tree().create_timer(0.2).timeout
		TEXTURE_LOCK = false
		await get_tree().create_timer(1.8).timeout
		INVINCIBLE = false
func _death():
	get_parent().call("_reset")
	TEXTURE_LOCK = true
	if not Autoloads.PLAYER_POSSESSING:
		$AnimatedSprite2D.play("hurt")
	await get_tree().create_timer(1).timeout
	$Camera2D/PlayerHealth.value = 10
	TEXTURE_LOCK = false
func _shoot():
	var SHOOT_BULLET = preload("res://scenes/player_projectile.tscn").instantiate()
	owner.add_child(SHOOT_BULLET)
	SHOOT_BULLET.position = position
func _ability_use(ability):
	match ability:
		"TARGET_DASH":
			$DetectShape/CollisionShape2D.disabled = false
			await get_tree().create_timer(1).timeout
			$DetectShape/CollisionShape2D.disabled = true
		"SHOOT":
			_shoot()
		"Jump":
			if is_on_floor():
				velocity.y = STATUS.jump * 2
			else:
				if Input.is_action_pressed("down"):
					velocity.y = STATUS.jump * -4
				else:
					velocity.y = STATUS.jump * 1.5
		"EXPLOSIVE":
			ABILITY_LOCK = true
			$ExtraAttack/CollisionShape2D.disabled = false
			$ExtraAttack/Sprite2D.visible = true
			if $Sprite2D.flip_h:
				$ExtraAttack.position = Vector2(-10, 0)
			if not $Sprite2D.flip_h:
				$ExtraAttack.position = Vector2(10, 0)
			await get_tree().create_timer(0.2).timeout
			$ExtraAttack/CollisionShape2D.disabled = true
			$ExtraAttack/Sprite2D.visible = false
			$ExtraAttack.position = Vector2(0, 0)
			ABILITY_LOCK = false
	if ability != "none" or ability != "spin":
		$Camera2D/DashRecover.value = 0
func _physics_process(delta: float) -> void:
	if INVINCIBLE_HOLD:
		if is_on_floor():
			_dash_hold_stop()
		if not is_on_floor():
			INVINCIBLE = true
			DASH_LOCK = true
			ATTACK_COLLISION = true
	if not TEXTURE_LOCK:
		$Sprite2D.visible = false
		$AnimatedSprite2D.visible = true
	if ATTACK_COLLISION:
		$AttackCollision/CollisionShape2D.disabled = false
	if not ATTACK_COLLISION:
		$AttackCollision/CollisionShape2D.disabled = true
	var standing = $groundchecker.get_collider()
	if standing:
		if standing.is_in_group("moving_tile") and Autoloads.is_moving:
			position.x += Autoloads.tile_move
		if standing.is_in_group("moving_tile_y") and Autoloads.is_moving:
			position.y -= Autoloads.tile_move / 2
	bodies = $ExtraAttack.get_overlapping_bodies()
	for body in bodies:
		if not body.is_in_group("tile_breakable"):
				break
		Autoloads.tile = body.local_to_map(body.position)
	if not SAVABLE:
		$Camera2D/Control/BoxContainer/TextureButton.visible = false
	if Input.is_action_just_pressed("shift"):
		if SAVABLE:
			$Camera2D/Control/BoxContainer/TextureButton.visible = true
			$Camera2D/PlayerHealth.value = 10
	if position.y > 175:
		get_parent().call("_reset")
	Autoloads.PLAYER_POSITION_X = position.x
	Autoloads.PLAYER_POSITION_Y = position.y
	move_and_slide()
	if Autoloads.PLAYER_POSSESSING:
		$AnimatedSprite2D.visible = false
		$Sprite2D.visible = true
		if Autoloads.POSSESS_ABILITY != "None":
			$Camera2D/DashRecover/Label.text = Autoloads.POSSESS_ABILITY
		else:
			$Camera2D/DashRecover/Label.text = ""
		if POSSESS_START:
			$Sprite2D.texture = load(Autoloads.POSSESS_SPRITE)
		POSSESS_START = false
		$PlayerIndicator.visible = true
		$PlayerIndicator.position = Vector2i(0, STATUS.hitbox_y / -2 - (STATUS.hitbox_y / 1.5))
		$Player_Shape.shape.size = Vector2(Autoloads.POSSESS_STATUS.hitbox_x, Autoloads.POSSESS_STATUS.hitbox_y)
		$PossessArea/PossessShape.disabled = true
		STATUS = Autoloads.POSSESS_STATUS
		if INVINCIBLE:
			$DamageCollision/PlayerDamageCollision.shape.size = Vector2(0, 0)
		if not DASH_MOVE:
			if Input.is_action_just_pressed("space") and $Camera2D/DashRecover.value == 60:
				_ability_use(Autoloads.POSSESS_ABILITY)
		match Autoloads.POSSESS_ABILITY:
			"Jump":
				direction = Input.get_axis("left", "right")
				if direction > 0:
					$Sprite2D.flip_h = false
				if direction < 0:
					$Sprite2D.flip_h = true
				if not is_on_floor():
					STATUS.slide = 0
					STATUS.damage_multiplier = -1.2
				else:
					STATUS.slide = 30
					STATUS.damage_multiplier = -1
				if not is_on_floor():
					if Input.is_action_pressed("down"):
						velocity += get_gravity() * delta * 2.5
					else:
						velocity += get_gravity() * delta * 1.5
				if is_on_floor():
					if Input.is_action_just_pressed("up") and CHARGE > 7:
						CHARGE = 0
						velocity.y = STATUS.jump
					CHARGE += 1
				if direction:
					if not is_on_floor():
						CHARGE = 0
						velocity.x = direction * STATUS.air_speed
					if is_on_floor():
						if CHARGE > 15:
							velocity.y = STATUS.jump
						velocity.x = 0
				if not direction:
					velocity.x = move_toward(velocity.x, 0, STATUS.slide)
					direction = 0
				$Sprite2D.texture = load(Autoloads.POSSESS_SPRITE)
			"SHOOT":
				if not is_on_floor():
					STATUS.slide = 2
					STATUS.damage_multiplier = -1.2
				else:
					STATUS.slide = 30
					STATUS.damage_multiplier = -1
				if not is_on_floor() and not Input.is_action_pressed("space"):
					if Input.is_action_pressed("down"):
						velocity += get_gravity() * delta * 1.5
					else:
						velocity += get_gravity() * delta / 5
				if $groundchecker.is_colliding():
					CHARGE = 0
				if not Input.is_action_pressed("space"):
					if $Camera2D/DashRecover.value == 60:
						_ability_use(Autoloads.POSSESS_ABILITY)
					else:
						$Camera2D/DashRecover.value = 0
					SPEED_MULTIPLIER = 1
					DASH_LOCK = true
				else:
					if $groundchecker.is_colliding():
						velocity.y = Input.get_axis("up", "down") * SPEED_MULTIPLIER * STATUS.air_speed
					if not $groundchecker.is_colliding():
						CHARGE += 1
						if CHARGE > 30:
							velocity.y = 30
						else:
							velocity.y = 0
					SPEED_MULTIPLIER = 0.25
					DASH_LOCK = false
				direction = Input.get_axis("left", "right")
				if not MOVE_LOCK or not ABILITY_LOCK:
					if direction > 0:
						$Sprite2D.flip_h = false
					if direction < 0:
						$Sprite2D.flip_h = true
					if Input.is_action_just_pressed("up") and not Input.is_action_pressed("space"):
						if is_on_floor():
							velocity.y = STATUS.jump / 2
						else:
							if $groundchecker.is_colliding():
								velocity.y = STATUS.jump / 4 
					if direction:
						if is_on_floor():
							velocity.x = direction * STATUS.speed * SPEED_MULTIPLIER
						if not is_on_floor():
							velocity.x = direction * STATUS.air_speed * SPEED_MULTIPLIER
					else:
						velocity.x = move_toward(velocity.x, 0, STATUS.slide)
						direction = 0
					if ABILITY_LOCK:
						velocity.x = move_toward(velocity.x, 0, STATUS.slide)
			"SPIN":
				Autoloads.move_amount = true
				if Input.is_action_just_pressed("ability"):
					Autoloads.move_amount = false
				if not Input.is_action_pressed("space"):
					$Camera2D.global_position = Autoloads.CAMERA_LOCATION
				else:
					$Camera2D.position = Vector2i(0, 0)
				velocity.x = 0
				velocity.y = 0
				position.x = Autoloads.PLAYER_POSITION_X
				position.y = Autoloads.PLAYER_POSITION_Y
				if Input.is_action_pressed("shift"):
					direction = Input.get_axis("left", "right") * 10
				else:
					direction = Input.get_axis("left", "right")
				Autoloads.tile_move = direction
				if direction:
					$Sprite2D.rotation_degrees += direction * 10
					$DamageCollision.rotation_degrees += direction * 10
			"TARGET_DASH":
				if HAS_TARGET == 2:
						position.x = move_toward(position.x, TARGET_POS.x, 2)
						position.y = move_toward(position.y, TARGET_POS.y, 2)
						await get_tree().create_timer(0.6).timeout
						HAS_TARGET = 0
				if not MOVE_LOCK:
					if direction > 0:
						$Sprite2D.flip_h = false
					if direction < 0:
						$Sprite2D.flip_h = true
					direction = Input.get_axis("left", "right")
					if direction:
						if is_on_floor():
							velocity.x = direction * STATUS.speed * SPEED_MULTIPLIER
						if not is_on_floor():
							velocity.x = direction * STATUS.air_speed * SPEED_MULTIPLIER
					else:
						velocity.x = move_toward(velocity.x, 0, STATUS.slide)
						direction = 0
					if ($groundchecker.is_colliding() or is_on_floor()) and Input.is_action_pressed("up"):
						velocity.y = STATUS.jump
					if not is_on_floor():
						if Input.is_action_pressed("down"):
							velocity.y = STATUS.jump * -1
						if not $groundchecker.is_colliding():
							velocity += get_gravity() * delta
						else:
							velocity.y = move_toward(velocity.y, 0, 30)
			"EXPLOSIVE":
				if $Camera2D/DashRecover.value == 0:
					$Sprite2D.texture = load("res://assets/placeholder_enemy_explosion.png")
				if not is_on_floor():
					STATUS.slide = 2
					STATUS.damage_multiplier = -1.2
				else:
					STATUS.slide = 30
					STATUS.damage_multiplier = -1
				if not is_on_floor():
					if Input.is_action_pressed("down"):
						velocity += get_gravity() * delta * 2.5
					else:
						velocity += get_gravity() * delta * 1.5
				if Input.is_action_just_pressed("space"):
					_charge_blink()
				if not Input.is_action_pressed("space"):
					SPEED_MULTIPLIER = 1
					DASH_LOCK = true
					if $Camera2D/DashRecover.value >= 60:
						_ability_use(Autoloads.POSSESS_ABILITY)
					else:
						$Camera2D/DashRecover.value = 0
				else:
					SPEED_MULTIPLIER = 0.25
					DASH_LOCK = false
				direction = Input.get_axis("left", "right")
				if not MOVE_LOCK or not ABILITY_LOCK:
					if direction > 0:
						$Sprite2D.flip_h = false
					if direction < 0:
						$Sprite2D.flip_h = true
					if is_on_floor():
						if Input.is_action_just_pressed("up"):
							velocity.x = 0
							velocity.y = STATUS.jump
					if direction:
						if is_on_floor():
							velocity.x = direction * STATUS.speed * SPEED_MULTIPLIER
						if not is_on_floor():
							velocity.x = direction * STATUS.air_speed * SPEED_MULTIPLIER
					else:
						velocity.x = move_toward(velocity.x, 0, STATUS.slide)
						direction = 0
					if ABILITY_LOCK:
						velocity.x = move_toward(velocity.x, 0, STATUS.slide)
			_:
				direction = Input.get_axis("left", "right")
				if direction > 0:
					$Sprite2D.flip_h = false
				if direction < 0:
					$Sprite2D.flip_h = true
				if not is_on_floor():
					STATUS.slide = 2
					STATUS.damage_multiplier = -1.2
				else:
					STATUS.slide = 30
					STATUS.damage_multiplier = -1
				if not is_on_floor():
					if Input.is_action_pressed("down"):
						velocity += get_gravity() * delta * 2.5
					else:
						velocity += get_gravity() * delta * 1.5
				if is_on_floor():
					if Input.is_action_just_pressed("up"):
						velocity.x = 0
						velocity.y = STATUS.jump
				if direction and not Input.is_action_pressed("space"):
					if is_on_floor():
						velocity.x = direction * STATUS.speed * SPEED_MULTIPLIER
					if not is_on_floor():
						velocity.x = direction * STATUS.air_speed * SPEED_MULTIPLIER
				else:
					velocity.x = move_toward(velocity.x, 0, STATUS.slide)
					direction = 0
		if Input.is_action_just_pressed("ability") or Autoloads.POSSESS_AMOUNT > 1 or POSSESS_END:
			POSSESS_END = false
			Autoloads.POSSESS_AMOUNT = 0
			Autoloads.tile_move = 0
			$Sprite2D.rotation = 0
			$DamageCollision.rotation = 0
			$Camera2D.position = Vector2i(0, 0)
			Autoloads.PLAYER_POSSESS_STOP = true
			Autoloads.PLAYER_POSSESSING = false
			POSSESS_START = true
			DASH_LOCK = false
			STATUS = {"speed": 120, "jump": -400, "damage_multiplier": -1, "slide": 0, "hitbox_x": 15.5, "hitbox_y": 15.5, "air_speed": 100}
			_health_process(0)
	if not Autoloads.PLAYER_POSSESSING:
		Autoloads.POSSESS_ENEMY = "none"
		Autoloads.POSSESS_TYPE = "none"
		$Camera2D/DashRecover/Label.text = "dash"
		$PlayerIndicator.visible = false
		DASH_LOCK = false
		if INVINCIBLE:
			$DamageCollision/PlayerDamageCollision.shape.size = Vector2(0, 0)
		if not DASH_MOVE:
			direction = Input.get_axis("left", "right")
			if direction > 0:
				$Sprite2D.flip_h = false
			if direction < 0:
				$Sprite2D.flip_h = true
			if not is_on_floor():
				STATUS.slide = 2
				STATUS.damage_multiplier = -1.2
			else:
				if CROUCH:
					STATUS.slide = 120
					STATUS.damage_multiplier = -0.8
				else:
					STATUS.slide = 15
					STATUS.damage_multiplier = -1
			if not is_on_floor():
				if Input.is_action_pressed("down"):
					velocity += get_gravity() * delta * 2.5
				else:
					velocity += get_gravity() * delta * 1.5
			if not TEXTURE_LOCK:
				if direction and not CROUCH:
					if not ANIMATION_MOVED:
						ANIMATION_MOVED = true
						$AnimatedSprite2D.play("move")
				if not direction and not CROUCH:
					if not ANIMATION_MOVED:
						ANIMATION_MOVED = true
						$AnimatedSprite2D.play("idle")
				if CROUCH:
					STATUS.speed = 30
					$Player_Shape.shape.size = Vector2(STATUS.hitbox_x, STATUS.hitbox_y / 2)
					$Player_Shape.position = Vector2(0, STATUS.hitbox_y / 4)
					if not INVINCIBLE:
						@warning_ignore("integer_division")
						$DamageCollision/PlayerDamageCollision.shape.size = Vector2(STATUS.hitbox_x - 0.5, STATUS.hitbox_y / 2 - 0.5)
						$DamageCollision/PlayerDamageCollision.position = Vector2(0, STATUS.hitbox_y / 4)
					if not ANIMATION_MOVED:
						$AnimatedSprite2D.play("crouch")
						ANIMATION_MOVED = true
					$Sprite2D.texture = load("res://assets/placeholder_player_crouch.png")
				if not CROUCH:
					ANIMATION_MOVED = false
					STATUS.speed = 120
					$Player_Shape.shape.size = Vector2(STATUS.hitbox_x, STATUS.hitbox_y)
					$Player_Shape.position = Vector2(0, 0)
					if not INVINCIBLE:
						@warning_ignore("integer_division")
						$DamageCollision/PlayerDamageCollision.shape.size = Vector2(STATUS.hitbox_x - 0.5, STATUS.hitbox_y - 0.5)
						$DamageCollision/PlayerDamageCollision.position = Vector2(0, 0)
					$Sprite2D.texture = load("res://assets/placeholder_player.png")
			if is_on_floor():
				if Input.is_action_pressed("down"):
					CROUCH = true
				else:
					if not CROUCH_BLOCK:
						CROUCH = false
				if Input.is_action_just_pressed("up"):
					velocity.y = STATUS.jump
			DASH_Y_CHANGE = Input.get_axis("up", "down")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
			if direction:
				if is_on_floor():
					velocity.x = direction * STATUS.speed * SPEED_MULTIPLIER
				if not is_on_floor():
					velocity.x = direction * STATUS.air_speed * SPEED_MULTIPLIER
			if not direction:
				velocity.x = move_toward(velocity.x, 0, STATUS.slide)
				direction = 0
			if $Camera2D/DashRecover.value == 60 and abs(direction) + abs(DASH_Y_CHANGE) != 0:
				if Input.is_action_just_pressed("space"): 
					DASH_LOCK = true
					$AnimatedSprite2D.visible = false
					$Sprite2D.visible = true
					if direction < 0:
						DASH_DIRECTION = -1
					if direction > 0:
						DASH_DIRECTION = 1
					if direction == 0:
						DASH_DIRECTION = 0
					DASH_MOVE = true
					INVINCIBLE = true
					$Sprite2D.texture = load("res://assets/placeholder_dash.png")
					$Camera2D/DashRecover.value = 0
					if DASH_DIRECTION == 0:
						velocity.x = 0
						$Sprite2D.flip_h = false
						$Sprite2D.rotation_degrees = -90
						if DASH_Y_CHANGE == 1:
							$Sprite2D.rotation_degrees = 90
							velocity.y = DASH_Y_CHANGE * STATUS.speed * 4
						else:
							velocity.y = DASH_Y_CHANGE * STATUS.speed * 4 / 1.5
					else:
						if DASH_Y_CHANGE != 0:
							$Sprite2D.texture = load("res://assets/placeholder_dash_diagonal.png")
							if DASH_Y_CHANGE == 1:
								$Sprite2D.flip_v = true
						velocity.y = DASH_Y_CHANGE * STATUS.speed * 4 / 3
					velocity.x = abs(STATUS.speed * 4 - abs(velocity.y)) * DASH_DIRECTION
					if Input.is_action_pressed("ability") or Input.is_action_pressed("shift"):
						ATTACK_COLLISION = true
					else:
						$PossessArea/PossessShape.disabled = false
					if DASH_Y_CHANGE == 1 and is_on_floor():
						position.y -= 10
						velocity.y = -200
						await get_tree().create_timer(0.01).timeout
						INVINCIBLE_HOLD = true
						ATTACK_COLLISION = true
						velocity.x = STATUS.speed * DASH_DIRECTION * 6
						$PossessArea/PossessShape.disabled = true
						await get_tree().create_timer(0.1).timeout
					else:
						await get_tree().create_timer(0.25).timeout
					$Sprite2D.flip_v = false
					$Sprite2D.rotation_degrees = 0
					DASH_Y_CHANGE = 0
					if not INVINCIBLE_HOLD:
						print("dash stop!")
						ATTACK_COLLISION = false
						DASH_LOCK = false
						INVINCIBLE = false
						$AnimatedSprite2D.visible = true
						$Sprite2D.visible = false
					if not (DASH_Y_CHANGE and is_on_floor()): 
						velocity.y = 0
						velocity.x = 0
					DASH_MOVE = false
					$PossessArea/PossessShape.disabled = true
					STATUS = {"speed": 120, "jump": -400, "damage_multiplier": -1, "slide": 0, "hitbox_x": 15.5, "hitbox_y": 15.5, "air_speed": 100}
func _process(_delta: float) -> void:
	if $Camera2D/DashRecover.value == 60:
		$Camera2D/DashRecover.texture_progress = load("res://assets/sprites/dash_bar_max.png")
	else:
		if Autoloads.POSSESS_TYPE == "charge":
			$Camera2D/DashRecover.texture_progress = load("res://assets/sprites/dash_bar_charge_charging.png")
		else:
			$Camera2D/DashRecover.texture_progress = load("res://assets/sprites/dash_bar_high.png")
	if Input.is_action_just_pressed("Any") and not DASH_MOVE:
		ANIMATION_MOVED = false
	if DASH_MOVE:
		$Sprite2D.visible = true
		$AnimatedSprite2D.visible = false
	if $Camera2D/PlayerHealth.value <= 3:
		$Camera2D/PlayerHealth.texture_progress = load("res://assets/sprites/health_bar_low.png")
	else:
		$Camera2D/PlayerHealth.texture_progress = load("res://assets/sprites/health_bar_high.png")
	_dash_recover_process(1)
	$AnimatedSprite2D.flip_h = $Sprite2D.flip_h
	$AnimatedSprite2D.flip_v = $Sprite2D.flip_v
	$AnimatedSprite2D.rotation = $Sprite2D.rotation
	if Autoloads.PLAYER_POSSESSING:
		$PossessArea/PossessShape.disabled = true
func _dash_recover_process(delta:float) -> void:
	if not DASH_LOCK:
		$Camera2D/DashRecover.value += delta
func _on_crouch_exit_test_area_body_exited(body) -> void:
	if body.is_in_group("tile"):
		CROUCH_BLOCK = false
		print("can crouch")
	if body.is_in_group("save"):
		SAVABLE = false 
func _on_crouch_test_area_body_entered(body) -> void:
	if body.is_in_group("tile"):
		CROUCH_BLOCK = true

func _on_damage_collision_area_entered(area) -> void:
	if area.is_in_group("damage"):
		ENEMY_COLLISION = true
		if not INVINCIBLE:
			velocity.y = -200
		if area.is_in_group("damage_2"):
			INVINCIBLE = false
			_health_process(5)
		_health_process(1)
		print(INVINCIBLE)
func _on_damage_collision_area_exited(area) -> void:
	if area.is_in_group("damage"):
		ENEMY_COLLISION = false
func _on_crouch_exit_test_area_body_entered(body) -> void:
	if body.is_in_group("save"):
		SAVABLE = true
		OVERLAPPING_SAVE = body.get_parent()
		print("can save")
func _on_detect_shape_body_entered(body: Node2D) -> void:
	TARGET_POS = Vector2i(0, 0)
	ATTACK_COLLISION = true
	velocity = Vector2i(0, 0)
	if HAS_TARGET == 0:
		INVINCIBLE = true
		MOVE_LOCK = true
		velocity.x = 0
		velocity.y = 0
		HAS_TARGET = 1
		if body.position.x - global_position.x > 0:
			direction = 1
		else:
			direction = -1
		if body.position.x > global_position.x:
			TARGET_POS.x = body.position.x + 150
		if body.position.x < global_position.x:
			TARGET_POS.x = body.position.x - 150
		if body.position.y > global_position.y:
			TARGET_POS.y = body.position.y + 150
		if body.position.y < global_position.y:
			TARGET_POS.y = body.position.y - 150
		await get_tree().create_timer(0.25).timeout
		HAS_TARGET = 2
		INVINCIBLE = false
		MOVE_LOCK = false
		ATTACK_COLLISION = false
func _charge_blink():
	while Input.is_action_pressed("space"):
		await get_tree().create_timer(0.3).timeout
		$Sprite2D.texture = load("res://assets/placeholder_enemy_explosive_charge.png")
		await get_tree().create_timer(0.3).timeout
		$Sprite2D.texture = load("res://assets/placeholder_enemy_explosion.png")
func _on_loaded_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.add_to_group("is_on_screen")
func _on_loaded_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.remove_from_group("is_on_screen")
