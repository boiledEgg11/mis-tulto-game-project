extends CharacterBody2D
var direction = -1
var health = 1
var possess_health = 1
var SLIDE
var INVINCIBLE = false
var Initial = Vector2(0, 0)
var POSSESSED = false
var STATUS = {"speed": 0, "jump": 0, "slide": 200, "damage_multiplier": -0.8, "hitbox_y": 22, "hitbox_x": 22, "air_speed": 0, "damage": 1, "extra_damage": 1}
func _ready() -> void:
	Initial = position
	$EnemyArea/CollisionShape2D.disabled = false
func _physics_process(delta: float) -> void:
	move_and_slide()
	if possess_health > 0:
		Autoloads.tile_move = 0.5
		velocity = Vector2(0, 0)
		POSSESSED = false
		rotation += 0.1
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
	if possess_health == -1:
		Autoloads.PLAYER_POSITION_X = Initial.x
		Autoloads.PLAYER_POSITION_Y = Initial.y
		rotation = 0
		INVINCIBLE = true
		POSSESSED = true
		$EnemyArea/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		if Autoloads.PLAYER_POSSESS_STOP:
			_possess_stop()
func _on_left_collision_check_body_entered(body: Node2D) -> void:
	direction = 1
	$Sprite2D.flip_h = false
func _on_right_collision_check_body_entered(body: Node2D) -> void:
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
func _process(delta: float) -> void:
	if not Autoloads.PLAYER_POSSESSING and POSSESSED:
		_possess_stop()
	if Autoloads.POSSESS_AMOUNT > 1:
		_possess_stop()
	if health == 0:
		queue_free()
	if Autoloads.POSSESS_AMOUNT > 1:
		_possess_stop()
	if health < 0:
		queue_free()
	if possess_health == 0:
		Autoloads.PLAYER_POSITION_X = Initial.x
		Autoloads.PLAYER_POSITION_Y = Initial.y
		Autoloads.POSSESS_AMOUNT += 1
		Autoloads.POSSESS_ABILITY = "SPIN"
		Autoloads.POSSESS_ENEMY = "SPIN"
		Autoloads.POSSESS_STATUS = STATUS
		possess_health = -1
		Autoloads.POSSESS_SPRITE = "res://assets/placeholder_gear.png"
		Autoloads.PLAYER_POSSESSING = true
		velocity.x = 0
		velocity.y = 0
