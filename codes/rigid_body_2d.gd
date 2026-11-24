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
	"tag": ["no_recover_usage"]
}
@export var stats: Dictionary = {
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
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _physics_process(delta: float) -> void:
	if START:
		match stats.individual:
			1:
				print("yay")
				position = Vector2(98, 0)
			2:
				position = Vector2(-20, 0)
			3:
				position = Vector2i(-208, 24)
			_:
				print("none")
				position = Vector2i(0, 0)
		START = false
	move_and_slide()
	if possess_health > 0:
		if not ground_exist:
			direction *= -1
			ground_exist = true
		var standing = $GroundExistingChecker2.get_overlapping_bodies()
		for body in standing:
				if body.is_in_group("tile_move"):
					position += body.tile_move_value
		if position.y > 175:
			queue_free()
		POSSESSED = false
		velocity.x = direction * stats.speed
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
		if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
	if possess_health == -1:
		INVINCIBLE = true
		POSSESSED = true
		$EnemyArea/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		if Autoloads.PLAYER_POSSESS_STOP:
			_possess_stop()
func _on_left_collision_check_body_entered(_body: Node2D) -> void:
	if $LeftCollisionCheck.area_entered:
		if stats.individual == 2 and is_on_floor():
			velocity.y = -250
			position.x -= 6 * direction
		else:
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
	global_position = Autoloads.player.global_position
	parent.global_position = global_position
	call_deferred("reparent", parent)
	Autoloads.PLAYER_POSSESS_STOP = false
	possess_health = 1
	velocity.y = -100
	velocity.x = 0
	health = 1
	$Sprite2D.visible = true
	await get_tree().create_timer(1).timeout
	INVINCIBLE = false
func _process(_delta: float) -> void:
	if not is_instance_valid(parent):
		print("dead...")
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
		parent.call_deferred("_erase")
	if possess_health == 0:
		_possess_start()
func _possess_start():
	get_parent().call_deferred("_possessed")
	Autoloads.POSSESS_AMOUNT += 1
	Autoloads.player.stats = stats
	possess_health = -1
	Autoloads.PLAYER_POSSESSING = true
	global_position = Autoloads.player.global_position
	velocity = Vector2(0, 0)
	call_deferred("reparent", Autoloads.player)
func _on_ground_existing_checker_body_exited(body: Node2D) -> void:
	if stats.individual == 3:
		if body.is_in_group("tile") and is_on_floor():
				ground_exist = false


func _on_ground_existing_checker_body_entered(body: Node2D) -> void:
	if stats.individual == 3:
		if body.is_in_group("tile") and is_on_floor():
				ground_exist = true
