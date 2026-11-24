extends CharacterBody2D
@export var DASHING = false
@export var direction = 1
@export var health = 10
@export var ENEMY_COLLISION = false
@export var DASH_Y_CHANGE = 0
@export var CROUCH = false
@export var DASH_DIRECTION = 0
@export var parent: Node2D
@export var DASH_MOVE = false
@export var POSSESS_END = false
@export var ANIMATION_MOVED = false
@export var CROUCH_BLOCK = false
@export var INVINCIBLE = false
@onready var KNOCKBACK_DURATION: float = 0
@export var INVINCIBLE_HOLD = false
@export var DEF_stats: Dictionary = {
	"speed": 120,
	"jump": -400,
	"slide": 60,
	"damage_multiplier": -1,
	"hitbox": Vector2(15.5, 15.5),
	"air_speed": 120,
	"damage": 1,
	"extra_damage": 5,
	"ability_display": "Dash",
	"ability": "Tulto",
	"species": "Tulto",
	"individual": 0,
	"sprite": "player_sprites",
	"tag": ["no_possess_stop"]
}
@export var stats: Dictionary = {
	"speed": 120,
	"jump": -400,
	"slide": 60,
	"damage_multiplier": -1,
	"hitbox": Vector2(15.5, 15.5),
	"air_speed": 120,
	"damage": 1,
	"extra_damage": 5,
	"ability_display": "Dash",
	"ability": "Tulto",
	"species": "Tulto",
	"individual": 0,
	"sprite": "player_sprites",
	"tag": ["no_possess_stop"]
}
@export var TEXTURE_LOCK: bool
@export var CHARGE = 0
@export var ABILITY_USE = true
@export var bodies: Array
@export var SAVABLE = false
@export var SAVE_THINGS: Dictionary
@export var DASH_LOCK = false
@export var MOVE_LOCK = false
@export var ABILITY_LOCK = false
@export var SPEED_MULTIPLIER = 1
@export var POSSESS_START = true
@export var TARGET_POS = Vector2(0, 0)
@export var ATTACK_COLLISION = false
@export var HAS_TARGET = 0
@export var OVERLAPPING_SAVE = "none"
@export var SAVE = preload("res://scenes/misc/save.tscn")
@export var MAP: Node2D
@export var treasure: Node
@export var treasure_gettable = false
@export var initial_y: int
@export var map_changable = 120
@export var fixed_camera = false
func _gravity(multiplier: float, value: float):
	velocity += get_gravity() * value * multiplier
func _movement(value: float, facing: int, air: bool):
	if KNOCKBACK_DURATION <= 0:
		if air:
			velocity.x = facing  * stats.air_speed * value
		else:
			velocity.x = facing * stats.speed * value
func _jump(value: float):
	velocity.y = stats.jump * value
func _facing(facing: int):
	if facing > 0:
		$Sprite2D.flip_h = false
	if facing < 0:
		$Sprite2D.flip_h = true
func _ready() -> void:
	Autoloads.player = self
	MAP = preload("res://scenes/tile_map/test_level_map.tscn").instantiate()
	owner.add_child.call_deferred(MAP)
	$ExtraAttack/Sprite2D.visible = false
	$CrouchTestArea/CollisionShape2D.shape.size = Vector2(15.5, 15.5)
	parent.call("_player_health", 10, true)
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
func _health_process(DAMAGE, knockback, way) -> void:
	if not INVINCIBLE:
		if not CROUCH:
			TEXTURE_LOCK = true
		if DAMAGE > 0:
			if not Autoloads.PLAYER_POSSESSING and not CROUCH:
				$AnimatedSprite2D.play("hurt")
			if knockback:
				velocity = Vector2(100 * way, -200)
				KNOCKBACK_DURATION = 2
				print("knockbacked!")
			parent.call("_player_health", DAMAGE * stats.damage_multiplier, false)
		if parent.call("_get_player_health") <= 0:
			_death()
		INVINCIBLE = true
		await get_tree().create_timer(0.2).timeout
		TEXTURE_LOCK = false
		await get_tree().create_timer(0.8).timeout
		INVINCIBLE = false
func _death():
	parent.call("_player_health", 10, true)
	parent.call("_reset", Autoloads.LAST_LOADED)
func _shoot():
	var SHOOT_BULLET = preload("res://scenes/projectile/player_projectile.tscn").instantiate()
	owner.add_child(SHOOT_BULLET)
	SHOOT_BULLET.position = position
func _big_slimy_ability():
	INVINCIBLE = true
	DASH_LOCK = true
	CHARGE = 0
	TARGET_POS = get_local_mouse_position()
	velocity.x = TARGET_POS.x * 2
	velocity.y = -200
func _ability_use(ability):
	print(ability)
	if stats.tag.has("no_recover_usage"):
		parent.call("_dash_recover", 0, true)
	match ability:
		"BigSlimy":
			Autoloads.POSSESS_ENEMY.call_deferred("_stomp_stop")
			call_deferred("_big_slimy_ability")
		"BladeShooter":
			if Autoloads.POSSESS_ENEMY.projectile_amount < 3:
				Autoloads.POSSESS_ENEMY.call_deferred("_summon_projectile", 3, false)
			else:
				Autoloads.POSSESS_ENEMY.call_deferred("_call_fly",get_global_mouse_position())
				parent.call("_dash_recover", 30, true)
		"Crystaline":
			Autoloads.POSSESS_ENEMY.call("_attack")
			Autoloads.PLAYER_ATTACK = true
		"WhistleDasher":
			$DetectShape/CollisionShape2D.disabled = false
			await get_tree().create_timer(1).timeout
			$DetectShape/CollisionShape2D.disabled = true
		"Dropper":
			_shoot()
		"Bouncer":
			if is_on_floor():
				_jump(2)
			else:
				if Input.is_action_pressed("down"):
					_jump(-4)
				else:
					_jump(1.5)
		"Pyrofighto":
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
	if not stats.tag.has("no_recover_usage"):
		parent.call_deferred("_dash_recover", 0, true)
func _physics_process(delta: float) -> void:
	if not fixed_camera:
		parent.call("_camera_position", position.x, position.y, false)
	if INVINCIBLE_HOLD:
		if is_on_floor():
			_dash_hold_stop()
		if not is_on_floor():
			INVINCIBLE = true
			DASH_LOCK = true
			ATTACK_COLLISION = true
	if KNOCKBACK_DURATION > 0:
		KNOCKBACK_DURATION -= 0.1
	if not TEXTURE_LOCK and not Autoloads.PLAYER_POSSESSING:
		$Sprite2D.visible = false
		$AnimatedSprite2D.visible = true
	if ATTACK_COLLISION:
		$AttackCollision/CollisionShape2D.disabled = false
	if not ATTACK_COLLISION:
		$AttackCollision/CollisionShape2D.disabled = true
	var standing = $GroundExistingChecker.get_overlapping_bodies()
	for body in standing:
			if body.is_in_group("tile_move"):
				position += body.tile_move_value
			if body.is_in_group("moving_tile"):
				if Autoloads.is_moving:
					position.x += Autoloads.tile_move
			if body.is_in_group("moving_tile_y") and Autoloads.is_moving:
				@warning_ignore("integer_division")
				position.y -= Autoloads.tile_move / 2
	bodies = $ExtraAttack.get_overlapping_bodies()
	for body in bodies:
		if not body.is_in_group("tile_breakable"):
				break
		Autoloads.tile = body.local_to_map(body.position)
	if Input.is_action_just_pressed("shift"):
		if SAVABLE:
			$PlayerIndicator.visible = false
			$Sprite2D.visible = false
			$AnimatedSprite2D.visible = false
			parent.call("_sprite_change", "BoxContainer", "visible")
			Autoloads.SAVE_SCREEN = true
			parent.get_parent().call("_pause")
			parent.call("_player_health", 10, true)
		if treasure_gettable:
			treasure.call_deferred("_found", self)
	if position.y > 175:
		parent.call("_reset", Autoloads.LAST_LOADED)
	move_and_slide()
	if Autoloads.PLAYER_POSSESSING:
		if stats.ability_display != "None":
			parent.call("_ability_label", stats.ability_display)
		else:
			parent.call("_ability_label", "")
		if POSSESS_START:
			$AnimatedSprite2D.visible = false
			$Sprite2D.visible = true
			$Sprite2D.texture = load(stats.sprite)
			POSSESS_START = false
			$PlayerIndicator.visible = true
			$GroundExistingChecker.position = Vector2(0, stats.hitbox.y / 2 + 0.5)
		$PlayerIndicator.position = Vector2i(0, stats.hitbox.y / -2 - (stats.hitbox.y / 1.5))
		$Player_Shape.shape.size = Vector2(stats.hitbox.x, stats.hitbox.y)
		$PossessArea/PossessShape.disabled = true
		if INVINCIBLE:
			$DamageCollision/PlayerDamageCollision.shape.size = Vector2(0, 0)
		if not DASH_MOVE:
			if Input.is_action_just_pressed("space") and parent.call("_get_dash_recover_value") == 60:
				_ability_use(stats.ability)
		match stats.species:
			"BigSlimy":
				if ABILITY_LOCK:
					$AttackCollision/CollisionShape2D.disabled = false
					_gravity(3, delta)
					if is_on_floor():
						Autoloads.POSSESS_ENEMY.call_deferred("_huge_stomp", velocity.x)
						ABILITY_LOCK = false
						DASH_LOCK = false
						await get_tree().process_frame
						await  get_tree().process_frame
						Autoloads.POSSESS_ENEMY.call_deferred("_stomp_start")
						$AttackCollision/CollisionShape2D.disabled = true
						INVINCIBLE = false
				if DASH_LOCK:
					CHARGE += 0.1
					if CHARGE > 3:
						velocity = Vector2(0, 0)
					if CHARGE > 3.7:
						CHARGE = 0
						ABILITY_LOCK = true
				if not DASH_LOCK:
					direction = Input.get_axis("left", "right")
					_facing(direction)
					if not is_on_floor():
						stats.slide = 0
						stats.damage_multiplier = -1.2
					else:
						stats.slide = 30
						stats.damage_multiplier = -1
					if not is_on_floor():
						if Input.is_action_pressed("down"):
							_gravity(2.5, delta)
						else:
							_gravity(1.5, delta)
					if is_on_floor():
						if Input.is_action_just_pressed("up") and CHARGE > 7:
							CHARGE = 0
							_jump(1)
						CHARGE += 1
					if direction:
						if not is_on_floor():
							CHARGE = 0
							_movement(1, direction, true)
						if is_on_floor():
							if CHARGE > 15:
								_jump(0.5)
							if KNOCKBACK_DURATION <= 0:
								velocity.x = 0
					if not direction:
						velocity.x = move_toward(velocity.x, 0, stats.slide)
						direction = 0
			"BladeShooter":
				direction = Input.get_axis("left", "right")
				_facing(direction)
				if not is_on_floor():
					stats.slide = 0
					stats.damage_multiplier = -1.2
				else:
					stats.slide = 30
					stats.damage_multiplier = -1
				if not is_on_floor():
					if Input.is_action_pressed("down"):
						_gravity(2.5, delta)
					else:
						_gravity(1.5, delta)
				if is_on_floor():
					if Input.is_action_just_pressed("up"):
						_jump(1)
				if direction:
					if not is_on_floor():
						_movement(1, direction, true)
					if is_on_floor():
						_movement(1, direction, false)
				if not direction:
					velocity.x = move_toward(velocity.x, 0, stats.slide)
					direction = 0
			"Crystaline":
				global_position = Autoloads.POSSESS_ENEMY.global_position
				global_rotation = Autoloads.POSSESS_ENEMY.global_rotation
				velocity.x = 0
				velocity.y = 0
				if is_on_floor():
					stats.slide = 100
				else:
					stats.slide = 45
				if not is_on_floor():
					_gravity(2.5, delta)
				if not Input.is_action_pressed("space"):
					DASH_LOCK = true
					if parent.call("_get_dash_recover_value") >= 60:
						_ability_use(stats.ability)
					else:
						parent.call("_dash_recover", 0, true)
				else:
					DASH_LOCK = false
			"Bouncer":
				direction = Input.get_axis("left", "right")
				_facing(direction)
				if not is_on_floor():
					stats.slide = 0
					stats.damage_multiplier = -1.2
				else:
					stats.slide = 30
					stats.damage_multiplier = -1
				if not is_on_floor():
					if Input.is_action_pressed("down"):
						_gravity(2.5, delta)
					else:
						_gravity(1.5, delta)
				if is_on_floor():
					if Input.is_action_just_pressed("up") and CHARGE > 7:
						CHARGE = 0
						_jump(1)
					CHARGE += 1
				if direction:
					if not is_on_floor():
						CHARGE = 0
						_movement(1, direction, true)
					if is_on_floor():
						if CHARGE > 15:
							_jump(1)
						velocity.x = 0
				if not direction:
					velocity.x = move_toward(velocity.x, 0, stats.slide)
					direction = 0
			"Dropper":
				if not is_on_floor():
					stats.slide = 2
					stats.damage_multiplier = -1.2
				else:
					stats.slide = 30
					stats.damage_multiplier = -1
				if not is_on_floor() and not Input.is_action_pressed("space"):
					if Input.is_action_pressed("down"):
						_gravity(1.5, delta)
					else:
						_gravity(0.2, delta)
				if $groundchecker.is_colliding():
					CHARGE = 0
				if not Input.is_action_pressed("space"):
					if parent.call("_get_dash_recover_value") == 60:
						_ability_use(stats.ability)
					else:
						parent.call("_dash_recover", 0, true)
					SPEED_MULTIPLIER = 1
					DASH_LOCK = true
				else:
					if $groundchecker.is_colliding():
						velocity.y = Input.get_axis("up", "down") * SPEED_MULTIPLIER * stats.air_speed
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
					_facing(direction)
					if Input.is_action_just_pressed("up") and not Input.is_action_pressed("space"):
						if is_on_floor():
							_jump(0.5)
						else:
							if $groundchecker.is_colliding():
								_jump(0.25)
					if direction:
						if is_on_floor():
							_movement(SPEED_MULTIPLIER, direction, false)
						if not is_on_floor():
							_movement(SPEED_MULTIPLIER, direction, true)
					else:
						velocity.x = move_toward(velocity.x, 0, stats.slide)
						direction = 0
					if ABILITY_LOCK:
						velocity.x = move_toward(velocity.x, 0, stats.slide)
			"Spinny":
				Autoloads.move_amount = true
				if Input.is_action_just_pressed("ability"):
					Autoloads.move_amount = false
				if not Input.is_action_pressed("space"):
					parent.call("_camera_position", Autoloads.CAMERA_LOCATION.x, Autoloads.CAMERA_LOCATION.y, true)
				else:
					parent.call("_camera_position", position.x, position.y, false)
				velocity.x = 0
				velocity.y = 0
				global_position = Autoloads.POSSESS_ENEMY.global_position
				global_rotation = Autoloads.POSSESS_ENEMY.global_rotation
				if Input.is_action_pressed("shift"):
					direction = Input.get_axis("left", "right") * 10
				else:
					direction = Input.get_axis("left", "right")
				Autoloads.tile_move = direction
				if direction:
					Autoloads.spin_moving = true
					$Sprite2D.rotation_degrees += direction * 10
					$DamageCollision.rotation_degrees += direction * 10
				else:
					Autoloads.spin_moving = false
			"WhistleDasher":
				if HAS_TARGET == 2:
					await get_tree().create_timer(0.6).timeout
					HAS_TARGET = 0
				if not MOVE_LOCK:
					_facing(direction)
					direction = Input.get_axis("left", "right")
					if direction and HAS_TARGET == 0:
						if is_on_floor():
							_movement(SPEED_MULTIPLIER, direction, false)
						if not is_on_floor():
							_movement(SPEED_MULTIPLIER, direction, true)
					else:
						velocity.x = move_toward(velocity.x, 0, stats.slide)
						direction = 0
					if ($groundchecker.is_colliding() or is_on_floor()) and Input.is_action_pressed("up"):
						_jump(0.25)
					if not is_on_floor():
						if Input.is_action_pressed("down"):
							_jump(-1)
						if not $groundchecker.is_colliding():
							_gravity(1, delta)
						else:
							velocity.y = move_toward(velocity.y, 0, 30)
			"Pyrofighto":
				if parent.call("_get_dash_recover_value") == 0:
					$Sprite2D.texture = load("res://assets/placeholders/placeholder_enemy_explosion.png")
				if not is_on_floor():
					stats.slide = 2
					stats.damage_multiplier = -1.2
				else:
					stats.slide = 30
					stats.damage_multiplier = -1
				if not is_on_floor():
					if Input.is_action_pressed("down"):
						_gravity(2.5, delta)
					else:
						_gravity(1.5, delta)
				if Input.is_action_just_pressed("space"):
					_charge_blink()
				if not Input.is_action_pressed("space"):
					SPEED_MULTIPLIER = 1
					DASH_LOCK = true
					if parent.call("_get_dash_recover_value") >= 60:
						_ability_use(stats.ability)
					else:
						parent.call("_dash_recover", 0, true)
				else:
					SPEED_MULTIPLIER = 0.25
					DASH_LOCK = false
				direction = Input.get_axis("left", "right")
				if not MOVE_LOCK or not ABILITY_LOCK:
					_facing(direction)
					if is_on_floor():
						if Input.is_action_just_pressed("up"):
							_jump(1)
					if direction:
						if is_on_floor():
							_movement(SPEED_MULTIPLIER, direction, false)
						if not is_on_floor():
							_movement(SPEED_MULTIPLIER, direction, true)
					else:
						velocity.x = move_toward(velocity.x, 0, stats.slide)
						direction = 0
					if ABILITY_LOCK:
						velocity.x = move_toward(velocity.x, 0, stats.slide)
			_:
				direction = Input.get_axis("left", "right")
				_facing(direction)
				if not is_on_floor():
					stats.slide = 2
					stats.damage_multiplier = -1.2
				else:
					stats.slide = 30
					stats.damage_multiplier = -1
				if not is_on_floor():
					if Input.is_action_pressed("down"):
						_gravity(2.5, delta)
					else:
						_gravity(1.5, delta)
				if is_on_floor():
					if Input.is_action_just_pressed("up"):
						_jump(1)
				if direction and not Input.is_action_pressed("space"):
					if is_on_floor():
						_movement(SPEED_MULTIPLIER, direction, false)
					if not is_on_floor():
						_movement(SPEED_MULTIPLIER, direction, true)
				else:
					velocity.x = move_toward(velocity.x, 0, stats.slide)
					direction = 0
		if Input.is_action_just_pressed("ability") or Autoloads.POSSESS_AMOUNT > 1 or POSSESS_END:
			rotation = 0
			INVINCIBLE  = true
			POSSESS_END = false
			Autoloads.POSSESS_AMOUNT = 0
			Autoloads.tile_move = 0
			$Sprite2D.rotation = 0
			$DamageCollision.rotation = 0
			Autoloads.PLAYER_POSSESS_STOP = true
			Autoloads.PLAYER_POSSESSING = false
			POSSESS_START = true
			DASH_LOCK = false
			stats = DEF_stats
			await get_tree().create_timer(0.2).timeout
			INVINCIBLE = false
	if not Autoloads.PLAYER_POSSESSING:
		parent.call("_ability_label", stats.ability_display)
		$PlayerIndicator.visible = false
		DASH_LOCK = false
		if INVINCIBLE:
			$DamageCollision/PlayerDamageCollision.shape.size = Vector2(0, 0)
		if not DASH_MOVE:
			direction = Input.get_axis("left", "right")
			_facing(direction)
			if not is_on_floor():
				stats.slide = 2
				stats.damage_multiplier = -1.2
			else:
				if CROUCH:
					stats.slide = 120
					stats.damage_multiplier = -0.8
				else:
					stats.slide = 15
					stats.damage_multiplier = -1
			if not is_on_floor():
				if Input.is_action_pressed("down"):
					_gravity(2.5, delta)
				else:
					_gravity(1.5, delta)
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
					stats.speed = 30
					$Player_Shape.shape.size = Vector2(stats.hitbox.x, stats.hitbox.y / 2)
					$Player_Shape.position = Vector2(0, stats.hitbox.y / 4)
					if not INVINCIBLE:
						@warning_ignore("integer_division")
						$DamageCollision/PlayerDamageCollision.shape.size = Vector2(stats.hitbox.x - 0.5, stats.hitbox.y / 2 - 0.5)
						$DamageCollision/PlayerDamageCollision.position = Vector2(0, stats.hitbox.y / 4)
					if not ANIMATION_MOVED:
						$AnimatedSprite2D.play("crouch")
						ANIMATION_MOVED = true
					$Sprite2D.texture = load("res://assets/placeholders/placeholder_player_crouch.png")
				if not CROUCH:
					ANIMATION_MOVED = false
					stats.speed = 120
					$Player_Shape.shape.size = Vector2(stats.hitbox.x, stats.hitbox.y)
					$Player_Shape.position = Vector2(0, 0)
					if not INVINCIBLE:
						@warning_ignore("integer_division")
						$DamageCollision/PlayerDamageCollision.shape.size = Vector2(stats.hitbox.x - 0.5, stats.hitbox.y - 0.5)
						$DamageCollision/PlayerDamageCollision.position = Vector2(0, 0)
					$Sprite2D.texture = load("res://assets/placeholders/placeholder_player.png")
			if is_on_floor():
				if Input.is_action_pressed("down"):
					CROUCH = true
				else:
					if not CROUCH_BLOCK:
						CROUCH = false
				if Input.is_action_just_pressed("up"):
					_jump(1)
			DASH_Y_CHANGE = Input.get_axis("up", "down")
			if direction:
				if is_on_floor():
					_movement(SPEED_MULTIPLIER, direction, false)
				if not is_on_floor():
					_movement(SPEED_MULTIPLIER, direction, true)
			if not direction:
				velocity.x = move_toward(velocity.x, 0, stats.slide)
				direction = 0
			if parent.call("_get_dash_recover_value") == 60 and abs(direction) + abs(DASH_Y_CHANGE) != 0:
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
					$Sprite2D.texture = load("res://assets/placeholders/placeholder_dash.png")
					parent.call("_dash_recover", 0, true)
					if DASH_DIRECTION == 0:
						velocity.x = 0
						$Sprite2D.flip_h = false
						$Sprite2D.rotation_degrees = -90
						if DASH_Y_CHANGE == 1:
							$Sprite2D.rotation_degrees = 90
							velocity.y = DASH_Y_CHANGE * stats.speed * 4
						else:
							velocity.y = DASH_Y_CHANGE * stats.speed * 4 / 1.5
					else:
						if DASH_Y_CHANGE != 0:
							$Sprite2D.texture = load("res://assets/placeholders/placeholder_dash_diagonal.png")
							if DASH_Y_CHANGE == 1:
								$Sprite2D.flip_v = true
						velocity.y = DASH_Y_CHANGE * stats.speed * 4 / 3
					velocity.x = abs(stats.speed * 4 - abs(velocity.y)) * DASH_DIRECTION
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
						_movement(6, DASH_DIRECTION, false)
						$PossessArea/PossessShape.disabled = true
						await get_tree().create_timer(0.1).timeout
					else:
						await get_tree().create_timer(0.25).timeout
					$Sprite2D.flip_v = false
					$Sprite2D.rotation_degrees = 0
					DASH_Y_CHANGE = 0
					if not INVINCIBLE_HOLD:
						ATTACK_COLLISION = false
						DASH_LOCK = false
						INVINCIBLE = false
						if not Autoloads.PLAYER_POSSESSING:
							$AnimatedSprite2D.visible = true
							$Sprite2D.visible = false
					if not (DASH_Y_CHANGE and is_on_floor()): 
						velocity.y = 0
						velocity.x = 0
					DASH_MOVE = false
					$PossessArea/PossessShape.disabled = true

func _process(_delta: float) -> void:
	if map_changable > 0:
		map_changable -= 1
	if parent.call("_get_dash_recover_value") == 60:
		parent.call("_sprite_change", "DashRecover", "max_dash")
	else:
		if stats.tag.has("charge"):
			parent.call("_sprite_change", "DashRecover", "charge_dash")
		else:
			parent.call("_sprite_change", "DashRecover", "normal")
	if Input.is_action_just_pressed("Any") and not DASH_MOVE:
		ANIMATION_MOVED = false
	if DASH_MOVE:
		$Sprite2D.visible = true
		$AnimatedSprite2D.visible = false
	if parent.call("_get_player_health") <= 3:
		parent.call("_sprite_change", "PlayerHealth", "low_health")
	else:
		parent.call("_sprite_change", "PlayerHealth", "high_health")
	_dash_recover_process(1)
	$AnimatedSprite2D.flip_h = $Sprite2D.flip_h
	$AnimatedSprite2D.flip_v = $Sprite2D.flip_v
	$AnimatedSprite2D.rotation = $Sprite2D.rotation
	if Autoloads.PLAYER_POSSESSING:
		$PossessArea/PossessShape.disabled = true
func _dash_recover_process(delta:float) -> void:
	if not DASH_LOCK:
		parent.call("_dash_recover", delta, false)
func _on_crouch_exit_test_area_body_exited(body) -> void:
	if body.is_in_group("tile"):
		CROUCH_BLOCK = false
		print("can crouch")
	if body.is_in_group("save"):
		SAVABLE = false 
	if body.is_in_group("treasure"):
		print("out of treasure")
		treasure_gettable = false
func _on_crouch_test_area_body_entered(body) -> void:
	if body.is_in_group("tile"):
		CROUCH_BLOCK = true
func _on_damage_collision_area_entered(area) -> void:
	if area.is_in_group("damage"):
		var knockback: int
		ENEMY_COLLISION = true
		if not INVINCIBLE:
			if area.global_position > global_position:
				knockback = -1
			else:
				knockback = 1
			if area.is_in_group("damage_2"):
				INVINCIBLE = false
				_health_process(5, true, knockback)
			else:
				_health_process(1, true, knockback)
		print("damaged!")
func _on_damage_collision_area_exited(area) -> void:
	if area.is_in_group("damage"):
		ENEMY_COLLISION = false
func _on_crouch_exit_test_area_body_entered(body) -> void:
	if body.is_in_group("save"):
		SAVABLE = true
		OVERLAPPING_SAVE = body.get_parent()
		print("can save")
	if body.is_in_group("treasure"):
		print("can treasure")
		treasure_gettable = true
		treasure = body

func _goal():
	parent.call("_open_text", 4, true)
	Progressions.progression.map_1_box = true
func _on_detect_shape_body_entered(body: Node2D) -> void:
	if HAS_TARGET == 0:
		INVINCIBLE = true
		MOVE_LOCK = true
		ATTACK_COLLISION = true
		$DetectShape/CollisionShape2D.call_deferred("set_disabled", true)
		HAS_TARGET = 1
		velocity = Vector2(0, 0)
		TARGET_POS = global_position - body.global_position
		await get_tree().create_timer(0.25).timeout
		velocity = TARGET_POS.normalized() * -190
		HAS_TARGET = 2
		INVINCIBLE = false
		MOVE_LOCK = false
		ATTACK_COLLISION = false
func _charge_blink():
	while Input.is_action_pressed("space"):
		await get_tree().create_timer(0.3).timeout
		$Sprite2D.texture = load("res://assets/placeholders/placeholder_enemy_explosive_charge.png")
		await get_tree().create_timer(0.3).timeout
		$Sprite2D.texture = load("res://assets/placeholders/placeholder_enemy_explosion.png")
func _on_loaded_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.add_to_group("is_on_screen")
func _on_loaded_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.remove_from_group("is_on_screen")
func _possess_revisible():
	$Sprite2D.visible = true
	$AnimatedSprite2D.visible = false
	$PlayerIndicator.visible = true
func _on_crouch_exit_test_area_area_entered(body) -> void:
	if body.is_in_group("goal"):
		print("congrats!")
		_goal()
		body.remove_from_group("goal")
func _change_map(next_map, location):
	parent.call("_set_data")
	parent.call("_erase_enemies")
	match next_map:
		"test_level_map_1":
			MAP.call_deferred("_erase")
			MAP = preload("res://scenes/tile_map/test_level_map.tscn").instantiate()
			match location:
				0:
					global_position = Vector2(0, 0)
				1:
					global_position = Vector2(912, -208)
			owner.add_child.call_deferred(MAP)
			parent.call("_erase_enemies")
			parent.call("_add_enemies", 0)
		"test_level_map_2":
			MAP.call_deferred("_erase")
			MAP = preload("res://scenes/tile_map/test_level_map_2.tscn").instantiate()
			match location:
				0:
					global_position = Vector2(0, 0)
				1:
					global_position = Vector2(24, 16)
				2:
					global_position = Vector2(-1144, 88)
				_:
					global_position = Vector2(0, 0)
			owner.add_child.call_deferred(MAP)
			parent.call("_erase_enemies")
			parent.call("_add_enemies", 1)
		"test_level_map_3":
			MAP.call_deferred("_erase")
			MAP = preload("res://scenes/tile_map/test_level_map_3.tscn").instantiate()
			match location:
				0:
					global_position = Vector2(0, 0)
				1:
					global_position = Vector2(24, 16)
				_:
					global_position = Vector2(0, 0)
			owner.add_child.call_deferred(MAP)
			parent.call("_erase_enemies")
			parent.call("_add_enemies", 2)
		"test_level_map_4":
			MAP.call_deferred("_erase")
			MAP = preload("res://scenes/tile_map/test_level_map_4.tscn").instantiate()
			match location:
				0:
					global_position = Vector2(0, 0)
				1:
					global_position = Vector2(0, -268)
			owner.add_child.call_deferred(MAP)
			parent.call("_erase_enemies")
			parent.call("_add_enemies", 3)
func _on_extra_attack_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("tile_breakable"):
		var tiles = body.get_coords_for_body_rid(body_rid)
		body.erase_cell(tiles)
func _raid_end():
	fixed_camera = false
	await get_tree().create_timer(0.2).timeout
	parent.call_deferred("_raid_end")
func _raid(map, area):
	match map:
		"test_level_4":
			fixed_camera = true
			parent.call_deferred("_raid", "test_map_4", area)
		_:
			pass
