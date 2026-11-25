extends CharacterBody2D
@export var direction: int = -1
@export var health: int = 10
@export var possess_health: int = 1
@export var START: bool = false
@export var INVINCIBLE: bool = false
@export var POSSESSED: bool = false
@export var attacking: bool = false
@export var charge: float = 0.0
@export var player_colliding: Node2D
@export var parent: Node2D
@export var parent_parent: Node2D
@onready var defeated: bool = false
@export var ground_exist: bool = true
@export var defeat_time: float = 0
@export var cooldown: float = 0
@export var charge_attack: bool = false
@export var target_position: Vector2
@export var destination: Vector2
@export var attack_time:float = 0.0
@onready var drop: bool = false
@onready var wait_time: float = 0
@onready var waiting: bool = false
@onready var after_wait: bool = false
@onready var no_stomp: bool = false
@onready var knockback: int = 0
@onready var move_lock: bool = false
@onready var return_position: Vector2
@onready var returning: bool = false
@onready var in_background: bool = false
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
	"speed": 75,
	"jump": -400,
	"slide": 60,
	"damage_multiplier": -0.6,
	"hitbox": Vector2(23.5, 23.5),
	"air_speed": 75,
	"damage": 1,
	"extra_damage": 5,
	"sprite": "res://assets/placeholders/placeholder_enemy_big.png",
	"ability_display": "JumpDrop!",
	"ability": "BigSlimy",
	"species": "BigSlimy",
	"tag": []
}
func _attack():
	after_wait = false
	target_position = global_position - Autoloads.player.global_position
	attacking = true
	velocity.x = target_position.x * -2
	velocity.y = -200
	print(velocity.y)
	cooldown = 0
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _background_attack():
	return_position = global_position
	velocity = Vector2(0, 0)
	move_lock = true
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, false)
	set_collision_layer_value(6, false)
	velocity.y = 100
func _background_reside():
	velocity = Vector2(0, 300)
	global_position = Vector2(312, -256)
	z_index = -2
	in_background =  true
func _end_background_attack():
	returning = true
	move_lock = false
	velocity = Vector2(0, 0)
	global_position = return_position + Vector2(0, -256)
	velocity.y = 10
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("4"):
		_background_reside()
	if Input.is_action_just_pressed("8"):
		_background_attack()
	if Input.is_action_just_pressed("9"):
		_end_background_attack()
	if START:
		match stats.individual:
			1:
				position = Vector2(98, 0)
			2:
				position = Vector2(-20, 0)
			3:
				position = Vector2i(-208, 24)
			_:
				position = Vector2i(0, 0)
		START = false
	move_and_slide()
	if possess_health > 0:
		if in_background:
			if global_position.y > -58:
				velocity.y = move_toward(velocity.y, 0, 30)
		if returning:
			print(global_position)
			velocity.y = move_toward(velocity.y, 300, 12)
			if global_position.y > 0:
				move_lock = false
				returning = false
				set_collision_mask_value(1, true)
				set_collision_mask_value(2, true)
				set_collision_layer_value(6, true)
		if move_lock:
			velocity.y = move_toward(velocity.y, -300, 12)
			if global_position.y < -300:
				move_lock = false
				_background_reside()
		if not (returning or move_lock or in_background):
			print("moving")
			if defeated:
				velocity.x = move_toward(velocity.x, 0, 10)
				velocity += get_gravity() * 1.5 * delta
			if not attacking or not charge_attack:
				cooldown += 0.1
				if cooldown > 24:
					charge_attack = true
					cooldown = 0
			if charge_attack and not defeated:
				charge += 0.1
				if charge > 3:
					_background_attack()
					charge_attack = false
					charge = 0
			if wait_time > 0:
				wait_time -= 0.1
				if wait_time <= 0:
					waiting = false
					cooldown = 0
			if attacking:
				attack_time += 0.1
				if attack_time > 3 and not after_wait and not waiting:
					waiting = true
					wait_time = 0.7
					velocity = Vector2(0, 0)
					after_wait = true
				if attack_time > 3 and not waiting and wait_time <= 0:
					attacking = false
					attack_time = 0
					drop = true
			if position.y > 175:
				queue_free()
			POSSESSED = false
			if not (defeated or attacking or drop or waiting or charge_attack):
				if not is_on_floor():
					velocity.x = direction * stats.air_speed * 1.5
				if is_on_floor():
					charge += 1
					velocity.x = 0
					if charge > 30:
						charge = 0
						velocity.y = -150
			$EnemyArea/CollisionShape2D.disabled = false
			$Sprite2D.visible = true
			if not (is_on_floor() or attacking or waiting):
				if drop:
					velocity += get_gravity() * delta * 2.5
				else:
					velocity += get_gravity() * delta * 1.5
	if possess_health == -1:
		global_position = Autoloads.player.global_position
		INVINCIBLE = true
		POSSESSED = true
		$EnemyArea/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		if Autoloads.PLAYER_POSSESS_STOP:
			_possess_stop()
func _on_left_collision_check_body_entered(_body: Node2D) -> void:
	if $LeftCollisionCheck.area_entered:
		if not (move_lock or returning or in_background):
			direction *= -1
func _on_enemy_area_area_entered(area:Node2D) -> void:
	if not INVINCIBLE:
		if not defeated:
			if area.is_in_group("player_damaging"):
				health -= 1
			if area.name == "PlayerProjectile":
				health -= 1
			if area.name == "AttackCollision":
				health -= 1
			if area.name == "ExtraAttack":
				health -= 5
		if area.name == "PossessArea":
			if defeated:
				possess_health -= 1
			else:
				health -= 1
		if area.global_position > global_position:
			knockback = -1
		else:
			knockback = 1
		if defeated:
			if area.name == "ExtraAttack":
				defeat_time += 30
			else:
				defeat_time += 6
		if health <= 0 and not defeated:
			defeated = true
			$Sprite2D.texture = load("res://assets/placeholders/placeholder_enemy_big_stun.png")
			velocity = Vector2(300 * knockback, -500)
			$EnemyArea.remove_from_group("damage")
func _possess_stop() -> void:
	print("possess stop")
	defeated = true
	POSSESSED = false
	global_position = Autoloads.player.global_position
	if is_instance_valid(parent):
		parent.global_position = global_position
		call_deferred("reparent", parent)
	Autoloads.PLAYER_POSSESS_STOP = false
	possess_health = 1
	velocity.y = -100
	velocity.x = 0
	health = 1
	$Sprite2D.texture = load("res://assets/placeholders/placeholder_enemy_big_stun.png")
	$Sprite2D.visible = true
	defeated = true
	$EnemyArea.remove_from_group("damage")
	await get_tree().create_timer(1).timeout
	INVINCIBLE = false
func _process(_delta: float) -> void:
	if defeated:
		defeat_time += 0.1
	if defeat_time > 24:
		if is_instance_valid(parent):
			parent.call_deferred("_erase")
		else:
			call_deferred("queue_free")
	$LeftCollisionCheck.position.x = 12 * direction
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
	if possess_health == 0:
		_possess_start()
func _possess_start():
	get_parent().call_deferred("_possessed")
	Autoloads.POSSESS_AMOUNT += 1
	Autoloads.player.stats = stats
	possess_health = -1
	Autoloads.PLAYER_POSSESSING = true
	velocity = Vector2(0, 0)
	defeated = false
	defeat_time = 0
	call_deferred("reparent", Autoloads.player)
func _on_ground_existing_checker_body_exited(body: Node2D) -> void:
	pass
func _on_ground_existing_checker_body_entered(body: Node2D) -> void:
	if body.is_in_group("tile"):
		pass
