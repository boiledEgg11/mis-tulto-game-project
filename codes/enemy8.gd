extends CharacterBody2D
@export var direction: int = -1
@export var health: int = 1
@export var possess_health: int = 1
@export var START: bool = false
@export var INVINCIBLE: bool = false
@export var POSSESSED: bool = false
@export var attacking: bool = false
@export var charge: float = 0.0
@export var parent: Node2D
@onready var INVINCIBLE_COUNT:bool = false
@onready var INVINCIBLE_COUNTER: float = 0
@export var parent_parent: Node2D
@export var default_stats: Dictionary = {
	"speed": 100,
	"jump": -400,
	"slide": 60,
	"damage_multiplier": -0.8,
	"hitbox": Vector2(15.5, 15.5),
	"air_speed": 100,
	"damage": 1,
	"extra_damage": 1,
	"sprite": "res://assets/placeholders/placeholder_enemy_sword.png",
	"ability_display": "Shoot swords",
	"ability": "BladeShooter",
	"species": "BladeShooter",
	"tag": []
}
@export var stats: Dictionary = {
	"speed": 80,
	"jump": -400,
	"slide": 60,
	"damage_multiplier": -0.8,
	"hitbox": Vector2(15.5, 15.5),
	"air_speed": 80,
	"damage": 1,
	"extra_damage": 1,
	"sprite": "res://assets/placeholders/placeholder_enemy_sword.png",
	"ability_display": "Shoot Swords!",
	"ability": "BladeShooter",
	"species": "BladeShooter",
	"tag": []
}
@export var projectile_cooldown = 0
@export var ground_exist = true
@export var forced_direction = false
@export var collision_layers: Array
@export var projectile_released = false
@export var projectile_exist = false
@export var projectile_time = 0
@export var WALL_EXISTED = false
@export var projectile_amount = 0
@export var projectile_exists: Array = [false, false, false, false, false]
@export var projectile: Array = [preload("res://scenes/misc/empty.tscn").instantiate(), preload("res://scenes/misc/empty.tscn").instantiate(), preload("res://scenes/misc/empty.tscn").instantiate(), preload("res://scenes/misc/empty.tscn").instantiate(), preload("res://scenes/misc/empty.tscn").instantiate()]
func _ready() -> void:
	parent_parent = parent.get_parent()
	$EnemyArea/CollisionShape2D.disabled = false
func _summon_projectile(summon_amount, attack_player: bool):
	print("summon!")
	print(summon_amount)
	for i in range(summon_amount):
		if not projectile_exists[i]:
			projectile_exist = true
			projectile_amount += 1
			projectile[i] = preload("res://scenes/projectile/enemy8_projectile.tscn").instantiate()
			projectile_exists[i] = true
			projectile[i].projectile_number = i
			$SpinManager.add_child(projectile[i])
			projectile[i].get_child(0).scale = Vector2(0.05, 0.05)
			projectile[i].get_child(0).position = Vector2(0, 0)
			projectile[i].attack_player = attack_player
			projectile[i].parent = self
			for l in range(0, i):
				projectile[l].rotation_degrees += 360 / summon_amount
	await get_tree().create_timer(0.2).timeout
	projectile_released = true
	if possess_health > 0:
		_enable_detect_collision()
func _projectile_erase(projectile_number):
	print("erased!")
	projectile[projectile_number]  = preload("res://scenes/misc/empty.tscn").instantiate()
	print(projectile_amount)
func _disable_collision_shape():
	$DetectionArea/CollisionShape2D.disabled = true
func _call_fly(position_target):
	call_deferred("_disable_collision_shape")
	projectile_cooldown = 0
	for child_projectile in $SpinManager.get_children(true):
		if position_target == null:
			child_projectile.call("_fly", null)
		else:
			child_projectile.call("_fly", position_target)
func _physics_process(delta: float) -> void:
	if START:
		match stats.individual:
			1:
				position = Vector2(-192, 0)
			2:
				position = Vector2(-504, -76)
			_:
				position = Vector2(0, 0)
		START = false
	if projectile_amount < 0:
		projectile_amount = 0
	for i in range(3):
		if is_instance_valid(projectile[i]):
			if projectile[i].get_child(0).scale < Vector2(1, 1):
				projectile[i].get_child(0).scale += Vector2(0.05, 0.05)
			if projectile[i].get_child(0).position.y > -50:
				projectile[i].get_child(0).position.y -= 2
	if Autoloads.player:
		if $DetectionArea.overlaps_body(Autoloads.player):
			_call_fly(null)

	$SpinManager.rotation_degrees += 3
	move_and_slide()
	if possess_health > 0:
		if not ground_exist:
			forced_direction = true
			direction *= -1
			ground_exist = true
			_forced_direction_fix()
		if projectile_amount < 3:
			_summon_projectile(3, true)
		var standing = $GroundExistingChecker.get_overlapping_bodies()
		for body in standing:
				if body.is_in_group("tile_move"):
					position += body.tile_move_value
		if position.y > 175:
			queue_free()
		POSSESSED = false
		if not forced_direction:
			if Autoloads.player and $DetectionArea/CollisionShape2D:
				if Autoloads.player.position.x > position.x:
					direction = -1
				if Autoloads.player.position.x < position.x:
					direction = 1
			if not $DetectionArea/CollisionShape2D.disabled and Autoloads.player:
				if Autoloads.player.position.x > position.x:
					direction = 1
				if Autoloads.player.position.x < position.x:
					direction = -1
		$EnemyArea/CollisionShape2D.disabled = false
		if  $DetectionArea/CollisionShape2D.disabled:
			velocity.x = direction * stats.speed / 1.25
		if not $DetectionArea/CollisionShape2D.disabled:
			velocity.x = direction * stats.speed
		$Sprite2D.visible = true
		if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
	if possess_health == -1:
		global_position = Autoloads.player.global_position
		INVINCIBLE = true
		POSSESSED = true
		$EnemyArea/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		if Autoloads.PLAYER_POSSESS_STOP:
			_possess_stop()
func _on_left_collision_check_body_entered(_body: Node2D) -> void:
	if $LeftCollisionCheck.area_entered:
		direction *= -1
func _on_enemy_area_area_entered(area) -> void:
	if not INVINCIBLE:
		if area.is_in_group("Autoloads.player_damaging"):
			health -= 1
		if area.name == "Autoloads.playerProjectile":
			health -= 1
			print("hit!")
		if area.name == "AttackCollision":
			health -= 1
		if area.name == "ExtraAttack":
			health -= 5
		if area.name == "PossessArea":
			possess_health -= 1
func _possess_stop() -> void:
	global_position = Autoloads.player.global_position
	parent.global_position = global_position
	parent.call_deferred("reparent", parent_parent)
	Autoloads.PLAYER_POSSESS_STOP = false
	possess_health = 1
	velocity.y = -100
	velocity.x = 0
	health = 1
	$EnemyTestCollision.disabled = false
	$Sprite2D.visible = true
	INVINCIBLE = true
	INVINCIBLE_COUNT = true
	INVINCIBLE_COUNTER = 0
func _process(_delta: float) -> void:
	if INVINCIBLE_COUNT:
		INVINCIBLE_COUNTER += 0.1
		if INVINCIBLE_COUNTER > 6:
			INVINCIBLE_COUNT = false
			INVINCIBLE = false
			INVINCIBLE_COUNTER = 0
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
		_possess_start()
func _forced_direction_fix():
	await get_tree().create_timer(0.5).timeout
	forced_direction = false

func _on_ground_existing_checker_body_exited(body: Node2D) -> void:
	if body.is_in_group("tile"):
		ground_exist = false

func _on_detection_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Autoloads.player"):
		_call_fly(null)
		Autoloads.player = body
func _enable_detect_collision():
	$DetectionArea/CollisionShape2D.disabled = false
func _on_ground_existing_checker_body_entered(body: Node2D) -> void:
	if body.is_in_group("tile"):
		ground_exist = true
func _possess_start():
	position = Vector2(0, 0)
	_projectile_erase(3)
	get_parent().call_deferred("_possessed")
	Autoloads.POSSESS_AMOUNT += 1
	Autoloads.player.stats = stats
	possess_health = -1
	Autoloads.PLAYER_POSSESSING = true
	global_position = Autoloads.player.global_position
	velocity = Vector2(0, 0)
	parent.call_deferred("reparent", Autoloads.player)
	Autoloads.POSSESS_ENEMY = self
	$EnemyTestCollision.disabled = true
	$DetectionArea/CollisionShape2D.disabled = true
