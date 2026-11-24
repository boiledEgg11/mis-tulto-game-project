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
	"speed": 0,
	"jump": -0,
	"slide": 200,
	"damage_multiplier": -0.25,
	"hitbox": Vector2(22, 22),
	"air_speed": 0,
	"damage": 1,
	"extra_damage": 1,
	"sprite": "res://assets/placeholders/placeholder_gear.png",
	"ability_display": "SPIN",
	"ability": "Spinny",
	"species": "Spinny",
	"tag": ["no_recover_usage"]
}
@export var stats: Dictionary = {
	"speed": 0,
	"jump": -0,
	"slide": 200,
	"damage_multiplier": -0.25,
	"hitbox": Vector2(22, 22),
	"air_speed": 0,
	"damage": 1,
	"extra_damage": 1,
	"sprite": "res://assets/placeholders/placeholder_gear.png",
	"ability_display": "SPIN",
	"ability": "Spinny",
	"species": "Spinny",
	"tag": ["no_recover_usage"]
}
@export var Initial = Vector2(0, 0)
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _physics_process(_delta: float) -> void:
	if START:
		match stats.individual:
			1:
				position = Vector2(512, -20)
			2:
				position = Vector2(1100, 30)
			3:
				position = Vector2i(-66 * 16, 80)
			_:
				position = Vector2i(0, 0)
		Initial = position
		START = false
	move_and_slide()
	if possess_health > 0:
		if position.y > 175:
			queue_free()
		velocity = Vector2(0, 0)
		POSSESSED = false
		rotation += 0.1
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
	if possess_health == -1:
		START = false
		if stats.individual == 1:
			Autoloads.CAMERA_LOCATION = Vector2i(816, 64)
		if stats.individual == 2:
			Autoloads.CAMERA_LOCATION = Vector2i(1232, 0)
		if stats.individual == 3:
			Autoloads.CAMERA_LOCATION = Vector2i(600, -104)
		Autoloads.PLAYER_POSITION_X = Initial.x
		Autoloads.PLAYER_POSITION_Y = Initial.y
		position = Initial
		rotation = 0
		INVINCIBLE = true
		POSSESSED = true
		$EnemyArea/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		if Autoloads.PLAYER_POSSESS_STOP:
			_possess_stop()
func _on_left_collision_check_body_entered(_body: Node2D) -> void:
	direction = 1
	$Sprite2D.flip_h = false
func _on_right_collision_check_body_entered(_body: Node2D) -> void:
	direction = -1
	$Sprite2D.flip_h = true
func _on_enemy_area_area_entered(area) -> void:
	if not INVINCIBLE:
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
func _process(_delta: float) -> void:
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
	Autoloads.POSSESS_ENEMY = self
	get_parent().call_deferred("_possessed")
	Autoloads.POSSESS_AMOUNT += 1
	Autoloads.player.stats = stats
	possess_health = -1
	Autoloads.PLAYER_POSSESSING = true
	global_position = Autoloads.player.global_position
	velocity = Vector2(0, 0)
