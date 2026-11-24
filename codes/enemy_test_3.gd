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
func _ready() -> void:
	parent_parent = get_parent().get_parent()
	$Area2D/Sprite2D.visible = false
	$EnemyArea/CollisionShape2D.disabled = false
func _charging():
	while attacking:
		await get_tree().create_timer(0.3).timeout
		if attacking:
			$Sprite2D.texture = load("res://assets/placeholders/placeholder_enemy_explosive_charge.png")
		await get_tree().create_timer(0.3).timeout
		if attacking:
			$Sprite2D.texture = load("res://assets/placeholders/placeholder_enemy_explosion.png")
func _attack_charge():
	charge = 1
	_charging()
	await get_tree().create_timer(2).timeout
	if possess_health > 0 and not INVINCIBLE:
		$Area2D.position = Vector2i(10 * direction, 0)
		velocity.x = 0
		$Area2D/CollisionShape2D.disabled = false
		$Area2D/Sprite2D.visible = true
		attacking = false
		$Sprite2D.texture = load("res://assets/placeholders/placeholder_enemy_explosion.png")
		await get_tree().create_timer(0.1).timeout
		$Area2D/CollisionShape2D.disabled = true
		$Area2D/Sprite2D.visible = false
	charge = 0
	direction *= -1
func _physics_process(delta: float) -> void:
	if START:
		match stats.individual:
			1:
				position = Vector2(250, 0)
			_:
				position = Vector2i(0, 0)
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
		if $player_detection.is_colliding():
			attacking = true
		if $RayCast2D.is_colliding():
			direction *= -1
		if direction == 1:
			$player_detection.rotation_degrees = 0 
			$player_detection.position = Vector2i(10, 0)
			$Sprite2D.flip_h = false
			$RayCast2D.rotation_degrees = 180
			$RayCast2D.position = Vector2i(-10, 0)
		if direction == -1:
			$player_detection.rotation_degrees = 180 
			$player_detection.position = Vector2i(-10, 0)
			$Sprite2D.flip_h = true
			$RayCast2D.rotation_degrees = 0
			$RayCast2D.position = Vector2i(10, 0)
		if not attacking and charge == 0:
			velocity.x = direction * stats.speed
		if attacking:
			velocity.x = direction * stats.speed / 2.5
			if charge == 0:
				_attack_charge()
		$EnemyArea/CollisionShape2D.disabled = false
		$Sprite2D.visible = true
		if not is_on_floor():
				velocity += get_gravity() * delta * 1.5
	if possess_health == -1:
		$Area2D/CollisionShape2D.disabled = true
		INVINCIBLE = true
		POSSESSED = true
		$EnemyArea/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		if Autoloads.PLAYER_POSSESS_STOP:
			_possess_stop()
func _on_left_collision_check_body_entered(_body: Node2D) -> void:
	if not attacking:
		direction = 1
	else:
		if is_on_floor():
			velocity.y = -300

func _on_right_collision_check_body_entered(_body: Node2D) -> void:
	if not attacking:
		direction = -1
	else:
		if is_on_floor():
			velocity.y = -300
func _on_enemy_area_area_entered(area) -> void:
	if not INVINCIBLE:
		if area.is_in_group("player_damaging") and area != $Area2D:
			health -= 1
		if area.name == "PlayerProjectile":
			health -= 1
		if area.name == "AttackCollision":
			health -= 1
		if area.name == "ExtraAttack":
			health -= 5
		if area.name == "PossessArea":
			possess_health -= 1
			player_colliding = area.get_parent()
func _possess_stop() -> void:
	call_deferred("reparent", parent)
	global_position = Autoloads.player.global_position
	if is_instance_valid(parent):
		parent.call_deferred("_possess_end")
		parent.global_position = global_position
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
		print("dead3...")
	if INVINCIBLE:
		attacking = false
	if direction == 1:
		$player_detection.rotation_degrees = 0 
		$player_detection.position = Vector2i(10, 0)
		$Sprite2D.flip_h = false
		$RayCast2D.rotation_degrees = 180
		$RayCast2D.position = Vector2i(-20, 0)
	if direction == -1:
		$player_detection.rotation_degrees = 180 
		$player_detection.position = Vector2i(-10, 0)
		$Sprite2D.flip_h = true
		$RayCast2D.rotation_degrees = 0
		$RayCast2D.position = Vector2i(10, 0)
	if not Autoloads.PLAYER_POSSESSING and POSSESSED:
		_possess_stop()
	if Autoloads.POSSESS_AMOUNT > 1:
		_possess_stop()
	if health <= 0:
		get_parent().call_deferred("_erase")
	if possess_health == 0:
		_possess_start()

func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body.global_position.x > global_position.x:
		direction = 1
	if body.global_position.x < global_position.x:
		direction = -1
	attacking = true
func _possess_start():
	get_parent().call_deferred("_possessed")
	Autoloads.POSSESS_AMOUNT += 1
	Autoloads.player.stats = stats
	possess_health = -1
	Autoloads.PLAYER_POSSESSING = true
	global_position = Autoloads.player.global_position
	velocity = Vector2(0, 0)
	call_deferred("reparent", Autoloads.player)
func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("tile_breakable"):
		var tiles = body.get_coords_for_body_rid(body_rid)
		body.erase_cell(tiles)
