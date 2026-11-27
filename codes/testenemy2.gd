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
@onready var possess_maintain: bool = false
@onready var possess_maintain_timer: float = 0
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
		if position.y > 175 and not POSSESSED:
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
	call_deferred("reparent", parent)
	if is_instance_valid(parent):
		parent.global_position = global_position
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
			INVINCIBLE = false
			INVINCIBLE_COUNT = false
			INVINCIBLE_COUNTER = 0
	$LeftCollisionCheck.position.x = 8 * direction
	if direction == 1:
		$Sprite2D.flip_h = false
	if direction == -1:
		$Sprite2D.flip_h = true
	if Autoloads.POSSESS_AMOUNT != 1 and POSSESSED and not possess_maintain:
		print(Autoloads.POSSESS_AMOUNT)
		print(POSSESSED)
		print(possess_maintain)
		_possess_stop()
	if health <= 0:
		queue_free()
	if possess_health == 0:
		_possess_start()
	if possess_maintain:
		possess_maintain_timer -= 0.1
		if possess_maintain_timer < 0:
			possess_maintain = false
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
func _load_possess():
	possess_maintain = true
	possess_maintain_timer = 1
	get_parent().call_deferred("_possessed")
	Autoloads.POSSESS_AMOUNT += 1
	Autoloads.player.stats = stats
	possess_health = -1
	Autoloads.POSSESS_ENEMY = self
	Autoloads.PLAYER_POSSESSING = true
	global_position = Autoloads.player.global_position
	velocity = Vector2(0, 0)
	call_deferred("reparent", Autoloads.player)
