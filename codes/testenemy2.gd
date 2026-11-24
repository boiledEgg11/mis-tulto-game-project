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
@export var default_stats: Dictionary = {
	"speed": 80,
	"jump": -350,
	"slide": 60,
	"damage_multiplier": -0.8,
	"hitbox": Vector2(15.5, 15.5),
	"air_speed": 80,
	"damage": 1,
	"extra_damage": 5,
	"sprite": "res://assets/placeholders/placeholder_enemy_explosion.png",
	"ability_display": "EXPLOSIVE",
	"ability": "Pyrofighto",
	"species": "Pyrofighto",
	"tag": ["charge"]
}
@export var stats: Dictionary = {
	"speed": 80,
	"jump": -275,
	"slide": 60,
	"damage_multiplier": -0.8,
	"hitbox": Vector2(15.5, 15.5),
	"air_speed": 100,
	"damage": 1,
	"extra_damage": 5,
	"sprite": "res://assets/placeholders/placeholder_enemy_bouncy.png",
	"ability_display": "Super Jump!",
	"ability": "Bouncer",
	"species": "Bouncer",
	"tag": []
}
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _physics_process(delta: float) -> void:
	if START:
		match stats.individual:
			1:
				position = Vector2(250, 0)
			2:
				position = Vector2(-320, 70)
			_:
				position = Vector2i(250, 0)
		START = false
	move_and_slide()
	if possess_health > 0:
		var standing = $GroundExistingChecker.get_overlapping_bodies()
		for body in standing:
			if body.is_in_group("tile_move"):
				position += body.tile_move_value
		if position.y > 175:
			queue_free()
		POSSESSED = false
		if is_on_wall_only():
			direction *= -1
		if not is_on_floor():
			velocity.x = direction * stats.air_speed
		if is_on_floor():
			charge += 1
			velocity.x = 0
			if charge > 30:
				charge = 0
				velocity.y = stats.jump
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
		if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
		if velocity.x > 0:
			$Sprite2D.flip_h = false
		if velocity.x < 0:
			$Sprite2D.flip_h = true
	if possess_health == -1:
		INVINCIBLE = true
		POSSESSED = true
		$EnemyArea/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		if Autoloads.PLAYER_POSSESS_STOP:
			_possess_stop()
func _on_left_collision_check_body_entered(_body: Node2D) -> void:
	direction *= -1
func _on_enemy_area_area_entered(area) -> void:
	if not INVINCIBLE:
		if area.is_in_group("player_damaging"):
			health -= 1
		if area.name == "PlayerProjectile":
			health -= 1
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
	$LeftCollisionCheck.position.x = 8 * direction
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
func _possess_start():
	get_parent().call_deferred("_possessed")
	Autoloads.POSSESS_AMOUNT += 1
	Autoloads.player.stats = stats
	possess_health = -1
	Autoloads.PLAYER_POSSESSING = true
	global_position = Autoloads.player.global_position
	velocity = Vector2(0, 0)
	call_deferred("reparent", Autoloads.player)
