extends CharacterBody2D
@export var direction: int = -1
@export var health: int = 10
@export var possess_health: int = 1
@export var START: bool = false
@export var INVINCIBLE: bool = false
@export var POSSESSED: bool = false
@export var attacking: bool = false
@export var charge: float = 0.0
@export var player_colliding: Node2D
@export var parent: Node2D
@export var parent_parent: Node2D
@onready var defeated: bool = false
@export var ground_exist: bool = true
@export var defeat_time: float = 0
@onready var initial_position: Vector2
@export var cooldown: float = 0
@export var charge_attack: bool = false
@export var target_position: Vector2
@export var destination: Vector2
@onready var wait_time: float = 0
@onready var waiting: bool = false
@onready var no_stomp: bool = false
@onready var knockback: int = 0
@onready var move_lock: bool = false
@onready var return_position: Vector2
@onready var returning: bool = false
@onready var in_background: bool = false
@onready var background_return: bool = false
@onready var attack_charging: bool = false
@onready var random_value = RandomNumberGenerator.new()
@onready var projectile_cooldown: float = 0
@onready var stage: String = "idle"
@onready var shooting: bool = false
@export var default_stats: Dictionary = {
	"speed": 60,
	"jump": -250,
	"slide": 60,
	"damage_multiplier": -0.8,
	"hitbox": Vector2(15.5, 15.5),
	"air_speed": 60,
	"damage": 1,
	"extra_damage": 5,
	"sprite": "res://assets/placeholders/placeholder_enemy.png",
	"ability_display": "None",
	"ability": "Slimy",
	"species": "Slimy",
	"tag": ["no_recover_usage"]
}
@export var stats: Dictionary = {
	"speed": 75,
	"jump": -400,
	"slide": 60,
	"damage_multiplier": -0.6,
	"hitbox": Vector2(23.5, 23.5),
	"air_speed": 75,
	"damage": 1,
	"extra_damage": 5,
	"sprite": "res://assets/placeholders/placeholder_enemy_big.png",
	"ability_display": "JumpDrop!",
	"ability": "BigSlimy",
	"species": "BigSlimy",
	"tag": []
}
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _background_attack():
	velocity = Vector2(0, 0)
	return_position = global_position
	move_lock = true
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, false)
	set_collision_layer_value(6, false)
	velocity.y = 100
func _background_reside():
	scale = Vector2(0.5, 0.5)
	$EnemyArea/CollisionShape2D.disabled = true
	Autoloads.tile_move[3] = 0
	move_lock = false
	velocity = Vector2(0, 300)
	global_position = Vector2(312, -256)
	z_index = -2
	in_background =  true
	charge = 0
func _end_background_reside():
	in_background = false
	velocity = Vector2(0, 100)
	background_return = true
func _end_background_attack():
	scale = Vector2(1, 1)
	$EnemyArea/CollisionShape2D.disabled = false
	z_index = 0
	in_background =  false
	returning = true
	move_lock = false
	velocity = Vector2(0, 0)
	global_position = return_position + Vector2(0, -256)
	velocity.y = 10
func _charge_attack():
	attack_charging = true
func _movement_logic(delta):
	match stage:
		"landing":
			velocity.x = move_toward(velocity.x, 0, 15)
			velocity.y = move_toward(velocity.y, -200, 15)
			charge += 0.1
			if charge > 3:
				print("landing!")
				charge = 0
				stage = "land_wait"
		"move":
			velocity.x = 100 * direction
			charge += 0.1
			if charge > 12:
				velocity.y = 100
				charge = 0
				stage = "landing"
			velocity.y = move_toward(velocity.y, 0, 25)
		"idle":
			if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
			if is_on_floor():
				_stay_attack()
		"land_wait":
			if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
			if is_on_floor():
				_shooot_attack()
		"shooting":
			charge += 0.1
			projectile_cooldown += 0.1
			if projectile_cooldown > 1.5:
				var easy_projectile = preload("res://scenes/projectile/enemy10_easy_projectile.tscn").instantiate()
				owner.add_child.call_deferred(easy_projectile)
				easy_projectile.call_deferred("_start", global_position, Autoloads.player.position + Vector2(random_value.randf_range(-5, 5), random_value.randf_range(-5, 5)))
				projectile_cooldown = 0
			if charge > 7.5:
				charge = 0
				velocity.y = -300
				stage = "move"
			if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
func _landing():
	velocity.y = -200
func _stay_attack():
	velocity = Vector2(0, 0)
	_shooot_attack()
	initial_position = position
func _shooot_attack():
	stage = "shooting"
func _attack_end():
	_end_background_reside()
func _physics_process(delta: float) -> void:
	if START:
		match stats.individual:
			1:
				position = Vector2(98, 0)
			2:
				position = Vector2(-20, 0)
			3:
				position = Vector2i(-208, 24)
			_:
				position = Vector2i(0, 0)
		START = false
	move_and_slide()
	if possess_health > 0:
		if attack_charging:
			projectile_cooldown += 0.1
			cooldown += 0.1
			if projectile_cooldown >= 0.4 and cooldown < 12:
				projectile_cooldown = 0
				_projectile_summon()
			if cooldown > 18:
				_attack_end()
				cooldown = 0
				attack_charging = false
		if background_return:
			velocity.y = move_toward(velocity.y, -300, 12)
			if global_position.y < -300:
				background_return = false
				_end_background_attack()
		if move_lock:
			Autoloads.tile_move[3] = -3.5
		if returning:
			Autoloads.tile_move[3] = 2.5
		if in_background:
			if global_position.y > -58:
				velocity.y = move_toward(velocity.y, 0, 30)
			charge += 0.1
			if charge > 12:
				charge = 0
				_charge_attack()
		if returning:
			velocity.y = move_toward(velocity.y, 300, 12)
			if global_position.y > 0:
				move_lock = false
				returning = false
				set_collision_mask_value(1, true)
				set_collision_mask_value(2, true)
				set_collision_layer_value(6, true)
				Autoloads.tile_move[3] = 0
		if move_lock:
			velocity.y = move_toward(velocity.y, -300, 12)
			if global_position.y < -300:
				move_lock = false
				_background_reside()
		if not (returning or move_lock or in_background or background_return):
			if defeated:
				velocity.x = move_toward(velocity.x, 0, 10)
				velocity += get_gravity() * 1.5 * delta
			cooldown += 0.1
			if cooldown > 24:
				cooldown = 0
				_background_attack()
			if position.y > 175:
				queue_free()
			POSSESSED = false
			if not (move_lock or defeated):
				_movement_logic(delta)
			$EnemyArea/CollisionShape2D.disabled = false
			$Sprite2D.visible = true
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
		if not (move_lock or returning or in_background or background_return):
			direction *= -1
func _on_enemy_area_area_entered(area:Node2D) -> void:
	if not INVINCIBLE:
		if not defeated:
			if area.is_in_group("player_damaging"):
				health -= 1
			if area.name == "PlayerProjectile":
				health -= 1
			if area.name == "AttackCollision":
				health -= 1
			if area.name == "ExtraAttack":
				health -= 5
		if area.name == "PossessArea":
			if defeated:
				possess_health -= 1
			else:
				health -= 1
		if area.global_position > global_position:
			knockback = -1
		else:
			knockback = 1
		if defeated:
			if area.name == "ExtraAttack":
				defeat_time += 30
			else:
				defeat_time += 6
		if health <= 0 and not defeated:
			defeated = true
			$Sprite2D.texture = load("res://assets/placeholders/placeholder_enemy_big_stun.png")
			velocity = Vector2(300 * knockback, -500)
			$EnemyArea.remove_from_group("damage")
func _possess_stop() -> void:
	print("possess stop")
	defeated = true
	POSSESSED = false
	global_position = Autoloads.player.global_position
	if is_instance_valid(parent):
		parent.global_position = global_position
		call_deferred("reparent", parent)
	Autoloads.PLAYER_POSSESS_STOP = false
	possess_health = 1
	velocity.y = -100
	velocity.x = 0
	health = 1
	$Sprite2D.texture = load("res://assets/placeholders/placeholder_enemy_big_stun.png")
	$Sprite2D.visible = true
	defeated = true
	$EnemyArea.remove_from_group("damage")
	await get_tree().create_timer(1).timeout
	INVINCIBLE = false
func _process(_delta: float) -> void:
	if defeated:
		defeat_time += 0.1
	if defeat_time > 24:
		if is_instance_valid(parent):
			parent.call_deferred("_erase")
		else:
			call_deferred("queue_free")
	$LeftCollisionCheck.position.x = 12 * direction
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
	if possess_health == 0:
		_possess_start()
func _possess_start():
	get_parent().call_deferred("_possessed")
	Autoloads.POSSESS_AMOUNT += 1
	Autoloads.player.stats = stats
	possess_health = -1
	Autoloads.PLAYER_POSSESSING = true
	velocity = Vector2(0, 0)
	defeated = false
	defeat_time = 0
	call_deferred("reparent", Autoloads.player)
func _on_ground_existing_checker_body_exited(body: Node2D) -> void:
	pass
func _on_ground_existing_checker_body_entered(body: Node2D) -> void:
	if body.is_in_group("tile"):
		pass
func _summoned(initial_size: Vector2, size_growth: Vector2, size_growth_speed: float, target_position: Vector2, parent):
	pass
func _projectile_summon():
	var projectile = preload("res://scenes/projectile/enemy10_projectile.tscn").instantiate()
	owner.add_child.call_deferred(projectile)
	projectile.call_deferred("_summoned", Vector2(0.1, 0.1), Vector2(random_value.randf_range(0.2, 0.5), random_value.randf_range(0.2, 0.5)), random_value.randf_range(0.75, 1.5), Vector2(random_value.randf_range(-144, 144), random_value.randf_range(-81, 81)), self)
