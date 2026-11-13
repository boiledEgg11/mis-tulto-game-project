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
var standing
var STATUS = {"speed": 60, "jump": -250, "slide": 60, "damage_multiplier": -0.8, "hitbox_y": 15.5, "hitbox_x": 15.5, "air_speed": 100, "damage": 1, "extra_damage": 1}
func _solved(place):
	match place:
		0:
			print("solved!")
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
				position = Vector2i(1016, -40)
				$Enemy7Laser._placement(0, 0, 0, -200)
			2:
				rotation_degrees = 180
				position = Vector2i(-248, -72)
				$Enemy7Laser._placement(0, 0, 0, -200)
			3:
				position = Vector2(-800, -24)
				$Enemy7Laser._placement(0, 0, 0, -100)
			4:
				position = Vector2(-816, -24)
				$Enemy7Laser._placement(0, 0, 0, -100)
			5:
				rotation_degrees = 90
				position = Vector2(487, -104)
				$Enemy7Laser._placement(0, 0, 0, -400)
			_:
				print("none")
				position = Vector2i(0, 0)
		START = false
	move_and_slide()
	standing = $GroundExistingChecker.get_overlapping_bodies()
	for body in standing:
		if not body.is_in_group("enemy7_cancel"):
			get_parent().reparent(body)
	if not standing:
		if individual != 5:
			velocity += get_gravity() * delta * 1.5
	if possess_health > 0:
		$Enemy7Laser/Line2D._attack_change(true)
		if not CHARGE_LOCK:
			CHARGE += 1
		if individual == 2 or individual == 3 or individual == 4 or individual == 5:
			CHARGE = 181
		if CHARGE > 180:
			CHARGE = 0
			_attack()
		if position.y > 175:
			queue_free()
		POSSESSED = false
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
	if possess_health == -1:
			if not Autoloads.PLAYER_ATTACK:
				_attack_end()
			$Enemy7Laser/Line2D._attack_change(false)
			INVINCIBLE = true
			POSSESSED = true
			Autoloads.PLAYER_POSITION_X = global_position.x
			Autoloads.PLAYER_POSITION_Y = global_position.y
			$EnemyArea/CollisionShape2D.disabled = true
			$Sprite2D.visible = false
			if Autoloads.PLAYER_POSSESS_STOP:
				_possess_stop()
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

	if CHARGE_LOW and individual != 2:
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
		Autoloads.POSSESS_SPRITE = "res://assets/placeholders/placeholder_crystal_enemy.png"
		Autoloads.PLAYER_POSSESSING = true
		velocity.x = 0
		velocity.y = 0


func _on_ground_existing_checker_body_exited(body: Node2D) -> void:
	if body.is_in_group("tile"):
		direction *= -1
