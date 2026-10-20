extends CharacterBody2D
var SPEED = 50
var direction = -1
var health = 5
var possess_health = 0
var SLIDE
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _physics_process(delta: float) -> void:
	move_and_slide()
	if possess_health != -1:
		if possess_health > health:
			possess_health = health
		velocity.x = direction * SPEED
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
		if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
	else:
		if possess_health == -1:
			position.x = Autoloads.PLAYER_POSITION_X
			position.y = Autoloads.PLAYER_POSITION_Y
			$EnemyArea/CollisionShape2D.disabled = true
			$Sprite2D.visible = false
			if Autoloads.PLAYER_POSSESS_STOP:
				possess_health = 5
				velocity.y = -100
				velocity.x = 0
func _on_left_collision_check_body_entered(body: Node2D) -> void:
	direction = 1
	$Sprite2D.flip_h = true
func _on_right_collision_check_body_entered(body: Node2D) -> void:
	direction = -1
	$Sprite2D.flip_h = false
func _on_enemy_area_area_entered(area) -> void:
	if area.name == "AttackCollision":
		health -= 1
		print("damaged")
	if area.name == "PossessArea":
		possess_health -= 1
func _process(delta: float) -> void:
	if health == 0:
		queue_free()
	if possess_health == 0:
		Autoloads.POSSESS_SPRITE = "res://assets/placeholder_enemy.png"
		Autoloads.PLAYER_POSSESSING = true
		position.x = Autoloads.PLAYER_POSITION_X
		position.y = Autoloads.PLAYER_POSITION_Y
		possess_health = -1
		velocity.x = 0
		velocity.y = 0
