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
	"jump": -400,
	"slide": 60,
	"damage_multiplier": -0.6,
	"hitbox": Vector2(23.5, 23.5),
	"air_speed": 60,
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
func _ready() -> void:
	$EnemyArea/CollisionShape2D.disabled = false
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("5"):
		_attack()
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
		if wait_time > 0:
			wait_time -= 0.1
			if wait_time <= 0:
				waiting = false
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
		if not (defeated or attacking or drop or waiting):
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
		if stats.individual == 2 and is_on_floor():
			velocity.y = -250
			position.x -= 6 * direction
		else:
			direction *= -1
func _on_enemy_area_area_entered(area) -> void:
	if not INVINCIBLE and not defeated:
		if area.is_in_group("player_damaging"):
			health -= 1
		if area.name == "PlayerProjectile":
			health -= 1
			print("hit!")
		if area.name == "AttackCollision":
			health -= 1
		if area.name == "ExtraAttack":
			health -= 5
	if not INVINCIBLE:
		if area.name == "PossessArea":
			if defeated:
				possess_health -= 1
			else:
				health -= 1
	if health <= 0 and not defeated:
		defeated = true
		$Sprite2D.texture = load("res://assets/placeholders/placeholder_enemy_big_stun.png")
		velocity = Vector2(0, 0)
func _possess_stop() -> void:
	print("possess stop")
	defeated = true
	POSSESSED = false
	global_position = Autoloads.player.global_position
	parent.global_position = global_position
	if is_instance_valid(parent):
		print("reparented!")
		call_deferred("reparent", parent)
	Autoloads.PLAYER_POSSESS_STOP = false
	possess_health = 1
	velocity.y = -100
	velocity.x = 0
	health = 1
	$Sprite2D.texture = load("res://assets/placeholders/placeholder_enemy_big_stun.png")
	$Sprite2D.visible = true
	defeated = true
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
		if not defeated and not drop:
			call_deferred("_stomp_attack", velocity.x)
		if drop:
			drop = false
			call_deferred("_huge_stomp", velocity.x)
			waiting = true
			wait_time = 5
func _huge_stomp(speed):
	var attack_1: Node2D = preload("res://scenes/projectile/enemy9_stomp_strong.tscn").instantiate()
	var attack_2:Node2D = preload("res://scenes/projectile/enemy9_stomp_strong.tscn").instantiate()
	Autoloads.center.add_child(attack_1)
	Autoloads.center.add_child(attack_2)
	attack_1.global_position = global_position + Vector2(0, 6)
	attack_2.global_position = global_position + Vector2(0, 6)
	attack_1.call_deferred("_summon", -1, possess_health, speed)
	attack_2.call_deferred("_summon", 1, possess_health, speed)
func _stomp_attack(speed):
	var attack_1: Node2D = preload("res://scenes/projectile/enemy9_stomp.tscn").instantiate()
	var attack_2:Node2D = preload("res://scenes/projectile/enemy9_stomp.tscn").instantiate()
	Autoloads.center.add_child(attack_1)
	Autoloads.center.add_child(attack_2)
	attack_1.global_position = global_position + Vector2(0, 6)
	attack_2.global_position = global_position + Vector2(0, 6)
	attack_1.call_deferred("_summon", -1, possess_health, speed)
	attack_2.call_deferred("_summon", 1, possess_health, speed)
