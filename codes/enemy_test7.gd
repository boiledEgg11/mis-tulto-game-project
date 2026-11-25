extends CharacterBody2D
@export var direction: int = -1
@export var health: int = 1
@export var possess_health: int = 1
@export var START: bool = false
@export var INVINCIBLE: bool = false
@export var POSSESSED: bool = false
@export var attacking: bool = false
@export var charge: float = 0.0
@export var player_colliding: Node2D
@export var parent: Node2D
@onready var INVINCIBLE_COUNT: bool = false
@onready var INVINCIBLE_COUNTER: float = 0
@export var parent_parent: Node2D
@export var ground_exist: bool = true
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
	"tag": [""]
}
@export var stats: Dictionary = {
	"speed": 0,
	"jump": 0,
	"slide": 60,
	"damage_multiplier": -0.8,
	"hitbox": Vector2(15.5, 15.5),
	"air_speed": 150,
	"damage": 1,
	"extra_damage": 5,
	"sprite": "res://assets/placeholders/placeholder_enemy_crystal.png",
	"ability_display": "Beam",
	"ability": "Crystaline",
	"species": "Crystaline",
	"tag": ["charge"]
}
var WALL_EXISTED = false
var CHARGE = 0
var CHARGE_LOCK = false
var CHARGE_LOW = false
var LAZER_DURATION = 120
var standing
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
		match stats.individual:
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
		if stats.individual != 5:
			velocity += get_gravity() * delta * 1.5
	if possess_health > 0:
		$Enemy7Laser/Line2D._attack_change(true)
		if not CHARGE_LOCK:
			CHARGE += 1
		if stats.individual == 2 or stats.individual == 3 or stats.individual == 4 or stats.individual == 5:
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
	global_position = Autoloads.player.global_position
	parent.global_position = global_position
	call_deferred("reparent", parent)
	Autoloads.PLAYER_POSSESS_STOP = false
	possess_health = 1
	velocity.y = -100
	velocity.x = 0
	health = 1
	$Sprite2D.visible = true
	INVINCIBLE = true
	INVINCIBLE_COUNT = true
	INVINCIBLE_COUNTER = 0
func _attack_end():
	CHARGE_LOW = false
	CHARGE_LOCK = false
	$Enemy7Laser.attacking = false
	CHARGE = 0
func _process(_delta: float) -> void:
	if INVINCIBLE_COUNT:
		INVINCIBLE_COUNTER += 0.1
		if INVINCIBLE_COUNTER > 6:
			INVINCIBLE_COUNT = false
			INVINCIBLE = false
			INVINCIBLE_COUNTER = 0

	if CHARGE_LOW and stats.individual != 2:
		LAZER_DURATION -= 1
		if LAZER_DURATION < 0:
			_attack_end()
	if direction == 1:
		$Sprite2D.flip_h = false
	if direction == -1:
		$Sprite2D.flip_h = true
	if Autoloads.POSSESS_AMOUNT > 1 and POSSESSED:
		_possess_stop()
	if health <= 0:
		queue_free()
	if possess_health == 0:
		_possess_start()
func _possess_start():
	CHARGE_LOW = false
	CHARGE_LOCK = false
	$Enemy7Laser.attacking = false
	CHARGE = 0
	get_parent().call_deferred("_possessed")
	Autoloads.POSSESS_AMOUNT += 1
	Autoloads.player.stats = stats
	possess_health = -1
	Autoloads.PLAYER_POSSESSING = true
	global_position = Autoloads.player.global_position
	velocity = Vector2(0, 0)
	call_deferred("reparent", Autoloads.player)
func _on_ground_existing_checker_body_exited(body: Node2D) -> void:
	if body.is_in_group("tile"):
		direction *= -1
