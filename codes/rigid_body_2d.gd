extends CharacterBody2D
var SPEED = 50
var direction = -1
var health = 2
var possess_health = 2
var SLIDE
var INVINCIBLE = false
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _physics_process(delta: float) -> void:
	if possess_health > health and health != 0:
		possess_health = health
	move_and_slide()
	if possess_health > 0:
		velocity.x = direction * SPEED
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
		if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
	else:
			INVINCIBLE = true
			position.x = Autoloads.PLAYER_POSITION_X
			position.y = Autoloads.PLAYER_POSITION_Y
			$EnemyArea/CollisionShape2D.disabled = true
			$Sprite2D.visible = false
			if Autoloads.PLAYER_POSSESS_STOP:
				_possess_stop()
func _possess_stop() -> void:
	Autoloads.PLAYER_POSSESS_STOP = false
	possess_health = 1
	velocity.y = -100
	velocity.x = 0
	health = 1
	await get_tree().create_timer(1).timeout
	INVINCIBLE = false
func _on_left_collision_check_body_entered(body: Node2D) -> void:
	direction = 1
	$Sprite2D.flip_h = true
func _on_right_collision_check_body_entered(body: Node2D) -> void:
	direction = -1
	$Sprite2D.flip_h = false
func _on_enemy_area_area_entered(area) -> void:
	if not INVINCIBLE:
		if area.name == "AttackCollision":
			health -= 1
			print("damaged")
		if area.name == "PossessArea":
			possess_health -= 1
			print("possessed")
func _process(delta: float) -> void:
		if health == 0:
			queue_free()
		if Autoloads.PLAYER_POSSESSING and possess_health > 0:
			possess_health = 0
		if possess_health == 0:
			Autoloads.POSSESS_STATUS = {"speed": 50, "jump": -250, "slide": 60, "damage_multiplier": -0.8, "hitbox_y": 15.5, "hitbox_x": 15.5}
			possess_health = -1
			Autoloads.POSSESS_SPRITE = "res://assets/placeholder_enemy.png"
			Autoloads.PLAYER_POSSESSING = true
			velocity.x = 0
			velocity.y = 0
