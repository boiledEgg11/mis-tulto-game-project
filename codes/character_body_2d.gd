extends CharacterBody2D
var DASHING = false
const DASH_SPEED = 480
var direction = 1
var health = 10
var ENEMY_COLLISION = false
var DASH_Y_CHANGE = 0
var CROUCH = false
var DASH_DIRECTION = 0
var DASH_MOVE = false
var CROUCH_BLOCK = false
var INVINCIBLE = false
var STATUS = {"speed": 120, "jump": -400, "damage_multiplier": -1, "slide": 0, "hitbox_x": 15.5, "hitbox_y": 15.5, "air_speed": 120, "damage": 1, "extra_damage": 1}
var TEXTURE_LOCK
var CHARGE = 0
var ABILITY_USE = true
var bodies
var SAVABLE = false
var OVERLAPPING_BODIES
var SAVE_THINGS
var location
var DASH_LOCK = false
var MOVE_LOCK = false
var ABILITY_LOCK = false
var SPEED_MULTIPLIER
func _ready() -> void:
	OVERLAPPING_BODIES = $CrouchExitTestArea.get_overlapping_bodies()
	$CrouchTestArea/CollisionShape2D.shape.size = Vector2(15.5, 15.5)
	$PlayerHealth.value = 10
	$AttackCollision/CollisionShape2D.disabled = true
	$PossessArea/PossessShape.disabled = true
	$DamageCollision/PlayerDamageCollision.disabled = false
	$DamageCollision/PlayerDamageCollision.shape.size = Vector2(10, 10)
func _health_process(DAMAGE) -> void:
	if not INVINCIBLE:
		TEXTURE_LOCK = true
		if DAMAGE > 0:
			$Sprite2D.texture = load("res://assets/placeholder_death.png")
			$PlayerHealth.value += DAMAGE * STATUS.damage_multiplier
		if $PlayerHealth.value <= 0:
			_death()
		INVINCIBLE = true
		await get_tree().create_timer(0.2).timeout
		TEXTURE_LOCK = false
		await get_tree().create_timer(1.8).timeout
		INVINCIBLE = false
func _collision(collision: KinematicCollision2D) -> void:
	if not collision:
		return
	var collision_pos = collision.get_position()
	var collision_opponent = collision.get_collider()
func _death():
	print("dead!")
	TEXTURE_LOCK = true
	velocity.y = -600
	$Sprite2D.texture = load("res://assets/placeholder_death.png")
	await get_tree().create_timer(1).timeout
	$PlayerHealth.value = 10
	TEXTURE_LOCK = false
func _ability_use(ability):
	match ability:
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
			if $Sprite2D.flip_h:
				$ExtraAttack/CollisionShape2D.position = Vector2(-10, 0)
			if not $Sprite2D.flip_h:
				$ExtraAttack/CollisionShape2D.position = Vector2(10, 0)
			await get_tree().create_timer(0.2).timeout
			$ExtraAttack/CollisionShape2D.disabled = true
			$ExtraAttack/CollisionShape2D.position = Vector2(0, 0)
			ABILITY_LOCK = false
	if ability != "None":
		$DashRecover.value = 0
func _save():
	$PlayerHealth.value = 10
	SAVE_THINGS = {"possess_enemy": Autoloads.POSSESS_ENEMY}
func _physics_process(delta: float) -> void:
	bodies = $ExtraAttack.get_overlapping_bodies()
	for body in bodies:
		if not body.is_in_group("tile_breakable"):
				break
		Autoloads.tile = body.local_to_map(body.position)
	if Input.is_action_pressed("shift"):
		if SAVABLE:
			_save()
	if position.y > 175:
		position.y = 0
		position.x = 0
		_health_process(5)
	Autoloads.PLAYER_POSITION_X = position.x
	Autoloads.PLAYER_POSITION_Y = position.y
	move_and_slide()
	if Autoloads.PLAYER_POSSESSING:
		$Player_Shape.shape.size = Vector2(Autoloads.POSSESS_STATUS.hitbox_x, Autoloads.POSSESS_STATUS.hitbox_y)
		$PossessArea/PossessShape.disabled = true
		STATUS = Autoloads.POSSESS_STATUS
		if INVINCIBLE:
			$DamageCollision/PlayerDamageCollision.shape.size = Vector2(0, 0)
		if not DASH_MOVE:
			if Input.is_action_just_pressed("space") and $DashRecover.value == 60:
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
			"EXPLOSIVE":
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
				if not Input.is_action_pressed("space"):
					$DashRecover.value = 0
					SPEED_MULTIPLIER = 1
					DASH_LOCK = true
				else:
					if $DashRecover.value == 60:
						_ability_use(Autoloads.POSSESS_ABILITY)
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
							velocity.x = direction * STATUS.speed * SPEED_MULTIPLIER
					else:
						velocity.x = move_toward(velocity.x, 0, STATUS.slide)
						direction = 0
					if ABILITY_LOCK:
						velocity.x = move_toward(velocity.x, 0, STATUS.slide)
				$Sprite2D.texture = load(Autoloads.POSSESS_SPRITE)
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
					if (velocity.x < (STATUS.speed * -1) and direction == -1) or (velocity.x > STATUS.speed and direction == 1):
						velocity.x += direction * delta * STATUS.speed / 20
					else:
						velocity.x = direction * STATUS.speed
				else:
					velocity.x = move_toward(velocity.x, 0, STATUS.slide)
					direction = 0
				$Sprite2D.texture = load(Autoloads.POSSESS_SPRITE)

		if Input.is_action_just_pressed("ability") or Autoloads.POSSESS_AMOUNT > 1:
			Autoloads.POSSESS_AMOUNT = 0
			Autoloads.PLAYER_POSSESS_STOP = true
			Autoloads.PLAYER_POSSESSING = false
			DASH_LOCK = false
			STATUS = {"speed": 120, "jump": -400, "damage_multiplier": -1, "slide": 0, "hitbox_x": 15.5, "hitbox_y": 15.5, "air_speed": 100}
			_health_process(0)
	if not Autoloads.PLAYER_POSSESSING:
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
				if CROUCH:
					STATUS.speed = 30
					$Player_Shape.shape.size = Vector2(STATUS.hitbox_x, STATUS.hitbox_y / 2)
					$Player_Shape.position = Vector2(0, STATUS.hitbox_y / 4)
					if not INVINCIBLE:
						$DamageCollision/PlayerDamageCollision.shape.size = Vector2(STATUS.hitbox_x * (2/3), STATUS.hitbox_y * (1/3))
						$DamageCollision/PlayerDamageCollision.position = Vector2(0, STATUS.hitbox_y / 4)
					$Sprite2D.texture = load("res://assets/placeholder_player_crouch.png")
				if not CROUCH:
					STATUS.speed = 120
					$Player_Shape.shape.size = Vector2(STATUS.hitbox_x, STATUS.hitbox_y)
					$Player_Shape.position = Vector2(0, 0)
					if not INVINCIBLE:
						$DamageCollision/PlayerDamageCollision.shape.size = Vector2(STATUS.hitbox_x * (2/3), STATUS.hitbox_y * (2/3))
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
				if (velocity.x < (STATUS.speed * -1) and direction == -1) or (velocity.x > STATUS.speed and direction == 1):
					velocity.x += direction * delta * STATUS.speed / 20
				else:
					velocity.x = direction * STATUS.speed
			if not direction:
				velocity.x = move_toward(velocity.x, 0, STATUS.slide)
				direction = 0
			if $DashRecover.value == 60 and abs(direction) + abs(DASH_Y_CHANGE) != 0:
				if Input.is_action_just_pressed("space"): 
					if direction < 0:
						DASH_DIRECTION = -1
					if direction > 0:
						DASH_DIRECTION = 1
					if direction == 0:
						DASH_DIRECTION = 0
					DASH_MOVE = true
					INVINCIBLE = true
					$Sprite2D.texture = load("res://assets/placeholder_dash.png")
					$DashRecover.value = 0
					if DASH_DIRECTION == 0:
						velocity.x = 0
						$Sprite2D.flip_h = false
						$Sprite2D.rotation_degrees = -90
						if DASH_Y_CHANGE == 1:
							$Sprite2D.rotation_degrees = 90
							velocity.y = DASH_Y_CHANGE * DASH_SPEED
						else:
							velocity.y = DASH_Y_CHANGE * DASH_SPEED / 1.5
					else:
						if DASH_Y_CHANGE != 0:
							$Sprite2D.texture = load("res://assets/placeholder_dash_diagonal.png")
							if DASH_Y_CHANGE == 1:
								$Sprite2D.flip_v = true
						velocity.y = DASH_Y_CHANGE * DASH_SPEED / 3
					velocity.x = abs(DASH_SPEED - abs(velocity.y)) * DASH_DIRECTION
					if Input.is_action_pressed("ability") or Input.is_action_pressed("shift"):
						$AttackCollision/CollisionShape2D.disabled = false
					else:
						$PossessArea/PossessShape.disabled = false
					if DASH_Y_CHANGE == 1 and is_on_floor():
						velocity.y = -200
						velocity.x = DASH_SPEED * DASH_DIRECTION * 1.5
						$AttackCollision/CollisionShape2D.disabled = false
						$PossessArea/PossessShape.disabled = true
						await get_tree().create_timer(0.1).timeout
					else:
						await get_tree().create_timer(0.25).timeout
					$Sprite2D.flip_v = false
					$Sprite2D.rotation_degrees = 0
					DASH_Y_CHANGE = 0
					INVINCIBLE = false
					DASH_MOVE = false
					if not (DASH_Y_CHANGE and is_on_floor()): 
						velocity.y = 0
						velocity.x = 0
					$AttackCollision/CollisionShape2D.disabled = true
					$PossessArea/PossessShape.disabled = true
func _process(delta: float) -> void:
	_dash_recover_process(1)
	if Autoloads.PLAYER_POSSESSING:
		$PossessArea/PossessShape.disabled = true

func _dash_recover_process(delta:float) -> void:
	if not DASH_LOCK:
		$DashRecover.value += delta * 1

func _on_crouch_exit_test_area_body_exited(body) -> void:
	if body.is_in_group("tile"):
		CROUCH_BLOCK = false
		print("can crouch")
	if body.is_in_group("save"):
		SAVABLE = false 


func _on_crouch_test_area_body_entered(body) -> void:
	if body.is_in_group("tile"):
		CROUCH_BLOCK = true
		print("cant crouch")

func _on_damage_collision_area_entered(area) -> void:
	if area.is_in_group("damage"):
		ENEMY_COLLISION = true
		if not INVINCIBLE:
			velocity.y = -200
		if area.is_in_group("damage_2"):
			_health_process(5)
		_health_process(1)
		print(INVINCIBLE)





func _on_damage_collision_area_exited(area) -> void:
	if area.is_in_group("damage"):
		ENEMY_COLLISION = false


func _on_crouch_exit_test_area_body_entered(body) -> void:
	if body.is_in_group("save"):
		SAVABLE = true
