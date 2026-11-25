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
@export var parent_parent: Node2D
@onready var INVINCIBLE_COUNT: bool = false
@onready var INVINCIBLE_COUNTER: float = 0
@export var ground_exist: bool = true
@export var default_stats: Dictionary = {
	"speed": 15,
	"jump": -250,
	"slide": 60,
	"damage_multiplier": -0.8,
	"hitbox": Vector2(15.5, 15.5),
	"air_speed": 70,
	"damage": 1,
	"extra_damage": 5,
	"sprite": "res://assets/placeholders/placeholder_enemy_dash.png",
	"ability_display": "Dash to target!",
	"ability": "WhistleDasher",
	"species": "WhistleDasher",
	"tag": [""]
}
@export var stats: Dictionary = {
	"speed": 15,
	"jump": -250,
	"slide": 60,
	"damage_multiplier": -0.8,
	"hitbox": Vector2(15.5, 15.5),
	"air_speed": 70,
	"damage": 1,
	"extra_damage": 5,
	"sprite": "res://assets/placeholders/placeholder_enemy_dash.png",
	"ability_display": "Dash to target!",
	"ability": "WhistleDasher",
	"species": "WhistleDasher",
	"tag": [""]
}
@export var TARGET_POS: Vector2
@export var HAS_TARGET = 0
@onready var initial_y: float
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _physics_process(delta: float) -> void:
	if START:
		match stats.individual:
			1:
				position = Vector2(0, 112)
				initial_y = 112
			_:
				position = Vector2i(0, 112)
		START = false
	move_and_slide()
	if possess_health > 0:
		if is_on_wall():
			direction *= -1
		var standing = $GroundExistingChecker.get_overlapping_bodies()
		for body in standing:
				if body.is_in_group("tile_move"):
					position += body.tile_move_value
		if position.y > 175:
			queue_free()
		INVINCIBLE = false
		POSSESSED = false
		$EnemyTestCollision.disabled = false
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
		if HAS_TARGET == 0:
			if global_position.y != initial_y:
				global_position.y = move_toward(global_position.y, initial_y, 15)
			velocity.x = direction * stats.air_speed
		if HAS_TARGET == 2:
			await get_tree().create_timer(0.6).timeout
			initial_y = global_position.y
			HAS_TARGET = 0
			await get_tree().process_frame
			$SearchArea/CollisionShape2D.call_deferred("set_disabled", false)
	if not is_on_floor():
			velocity += get_gravity() * delta / 5
	if possess_health == -1:
		$EnemyTestCollision.disabled = true
		INVINCIBLE = true
		POSSESSED = true
		$EnemyArea/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
func _on_left_collision_check_body_entered(_body: Node2D) -> void:
	direction = 1
func _on_right_collision_check_body_entered(_body: Node2D) -> void:
	direction = -1
func _possess_stop() -> void:
	global_position = Autoloads.player.global_position
	if is_instance_valid(parent):
		parent.global_position = global_position
		call_deferred("reparent", parent)
	else:
		call_deferred("reparent", Autoloads.center)
	Autoloads.PLAYER_POSSESS_STOP = false
	possess_health = 1
	velocity.y = -100
	velocity.x = 0
	health = 1
	$Sprite2D.visible = true
	INVINCIBLE = true
	INVINCIBLE_COUNT = true
	INVINCIBLE_COUNTER = 0
	Autoloads.player.call_deferred("_end_possess")
func _process(_delta: float) -> void:
	if INVINCIBLE_COUNT:
		INVINCIBLE_COUNTER += 0.1
		if INVINCIBLE_COUNTER > 6:
			INVINCIBLE_COUNT = false
			INVINCIBLE = false
			INVINCIBLE_COUNTER = 0
	if direction == 1:
		$Sprite2D.flip_h = false
		$RayCast2D.target_position = Vector2(50, 0)
	if direction == -1:
		$Sprite2D.flip_h = true
		$RayCast2D.target_position = Vector2(-50, 0)
	if Autoloads.POSSESS_AMOUNT > 1 and POSSESSED:
		_possess_stop()
	if health <= 0:
		queue_free()
	if possess_health == 0:
		_possess_start()
func _possess_start():
	get_parent().call_deferred("_possessed")
	Autoloads.POSSESS_AMOUNT += 1
	Autoloads.player.stats = stats
	possess_health = -1
	Autoloads.POSSESS_ENEMY = self
	Autoloads.PLAYER_POSSESSING = true
	global_position = Autoloads.player.global_position
	velocity = Vector2(0, 0)
	call_deferred("reparent", Autoloads.player)
func _on_search_area_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if HAS_TARGET == 0:
		$SearchArea/CollisionShape2D.call_deferred("set_disabled", true)
		HAS_TARGET = 1
		velocity = Vector2(0, 0)
		TARGET_POS = global_position - body.global_position
		TARGET_POS += Vector2(0, -10)
		await get_tree().create_timer(0.25).timeout
		velocity = TARGET_POS.normalized() * -190
		HAS_TARGET = 2
		print(TARGET_POS)
func _on_enemy_area_area_entered(area: Area2D) -> void:
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
			print("hit!")
