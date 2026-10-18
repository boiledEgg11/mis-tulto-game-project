extends CharacterBody2D
var SPEED = 120.0
var JUMP_VELOCITY = -400.0
var DASHING = false
const DASH_SPEED = 480
var direction = 1
var health = 10
var ENEMY_COLLISION = false
var DASH_Y_CHANGE = 0
var CROUCH = false
var SLIDE = 0
var DASH_DIRECTION = 0
var DASH_MOVE = false
var DAMAGE_MULTIPLIER = 1
var CROUCH_BLOCK = false
var INVINCIBLE = false
var floating = false
var TEXTURE_LOCK
func _ready() -> void:
	$CrouchTestArea/CollisionShape2D.shape.size = Vector2(15.5, 15.5)
	$PlayerHealth.value = 10
	$AttackCollision/CollisionShape2D.disabled = true
func _health_process(DAMAGE: float) -> void:
	if not INVINCIBLE:
		TEXTURE_LOCK = true
		$Sprite2D.texture = load("res://assets/placeholder_death.png")
		$PlayerHealth.value += DAMAGE * DAMAGE_MULTIPLIER
		if $PlayerHealth.value <= 0:
			_death()
		INVINCIBLE = true
		await get_tree().create_timer(0.2).timeout
		TEXTURE_LOCK = false
		await get_tree().create_timer(1.8).timeout
		INVINCIBLE = false
func _death():
	print("dead!")
	TEXTURE_LOCK = true
	velocity.y = -600
	$Sprite2D.texture = load("res://assets/placeholder_death.png")
	await get_tree().create_timer(1).timeout
	$PlayerHealth.value = 10
	TEXTURE_LOCK = false
func _physics_process(delta: float) -> void: 
	if INVINCIBLE:
		$DamageCollision/PlayerDamageCollision.shape.size = Vector2(0, 0)
	move_and_slide()
	if not DASH_MOVE:
		direction = Input.get_axis("left", "right")
		if direction > 0:
			$Sprite2D.flip_h = false
		if direction < 0:
			$Sprite2D.flip_h = true
		if not is_on_floor():
			SLIDE = 5
			DAMAGE_MULTIPLIER = 1.2
		else:
			if CROUCH:
				SLIDE = 120
				DAMAGE_MULTIPLIER = 0.8
			else:
				SLIDE = 30
				DAMAGE_MULTIPLIER = 1
		if not is_on_floor() and not floating:
			if Input.is_action_pressed("down"):
				velocity += get_gravity() * delta * 2.5
			else:
				velocity += get_gravity() * delta * 1.5
		if not TEXTURE_LOCK:
			if CROUCH:
				SPEED = 30
				$Player_Shape.shape.size = Vector2(15.5, 7.75)
				$Player_Shape.position = Vector2(0, 3.875)
				if not INVINCIBLE:
					$DamageCollision/PlayerDamageCollision.shape.size = Vector2(10, 5)
					$DamageCollision/PlayerDamageCollision.position = Vector2(0, 3.875)
				$Sprite2D.texture = load("res://assets/placeholder_player_crouch.png")
			if not CROUCH:
				SPEED = 120
				$Player_Shape.shape.size = Vector2(15.5, 15.5)
				$Player_Shape.position = Vector2(0, 0)
				if not INVINCIBLE:
					$DamageCollision/PlayerDamageCollision.shape.size = Vector2(10, 10)
					$DamageCollision/PlayerDamageCollision.position = Vector2(0, 0)
				$Sprite2D.texture = load("res://assets/placeholder_player.png")
		if is_on_floor():
			if Input.is_action_pressed("down"):
					CROUCH = true
			else:
				if not CROUCH_BLOCK:
					CROUCH = false
			if Input.is_action_just_pressed("up"):
				velocity.y = JUMP_VELOCITY
		DASH_Y_CHANGE = Input.get_axis("up", "down")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		if direction:
				velocity.x = SPEED * direction
		if not direction:
			velocity.x = move_toward(velocity.x, 0, SLIDE)
			direction = 0
		if $DashRecover.value == 60 and abs(direction) + abs(DASH_Y_CHANGE) != 0:
			if Input.is_action_just_pressed("space"): 
				if direction < 0:
					DASH_DIRECTION = -1
				if direction > 0:
					DASH_DIRECTION = 1
				DASH_MOVE = true
				INVINCIBLE = true
				$Sprite2D.texture = load("res://assets/placeholder_dash.png")
				$DashRecover.value = 0
				if direction == 0:
					velocity.x = 0
					$Sprite2D.flip_h = false
					$Sprite2D.rotation_degrees = -90
					if DASH_Y_CHANGE == 1:
						$Sprite2D.rotation_degrees = 90
						velocity.y = DASH_Y_CHANGE * DASH_SPEED
					else:
						velocity.y = DASH_Y_CHANGE * DASH_SPEED / 1.5
				else:
					if DASH_Y_CHANGE != 0:
						$Sprite2D.texture = load("res://assets/placeholder_dash_diagonal.png")
						if DASH_Y_CHANGE == 1:
							$Sprite2D.flip_v = true
					velocity.y = DASH_Y_CHANGE * DASH_SPEED / 3
					velocity.x = abs(DASH_SPEED - abs(velocity.y)) * DASH_DIRECTION
				if is_on_floor():
					velocity.y = DASH_SPEED / 6
				$AttackCollision/CollisionShape2D.shape.size = Vector2(17, 17)
				$AttackCollision/CollisionShape2D.disabled = false
				await get_tree().create_timer(0.25).timeout
				$Sprite2D.flip_v = false
				$Sprite2D.rotation_degrees = 0
				DASH_Y_CHANGE = 0
				INVINCIBLE = false
				DASH_MOVE = false
				velocity.x = 0
				velocity.y = 0
				$AttackCollision/CollisionShape2D.disabled = true
				$AttackCollision/CollisionShape2D.shape.size = Vector2(0, 0)
func _process(delta: float) -> void:
	_dash_recover_process(1)

func _dash_recover_process(delta:float) -> void:
	$DashRecover.value += delta * 1

func _on_crouch_exit_test_area_body_exited(body: TileMapLayer) -> void:
	CROUCH_BLOCK = false
	print("can crouch") 


func _on_crouch_test_area_body_entered(body: TileMapLayer) -> void:
	CROUCH_BLOCK = true
	print("cant crouch")

func _on_attack_collision_area_body_entered(body) -> void:
	if body.is_in_group("damage"):
		ENEMY_COLLISION = true
		if not INVINCIBLE:
			velocity.y = -200
		_health_process(-1)
		print(INVINCIBLE)

func _on_attack_collision_area_body_exited(body) -> void:
	if body.is_in_group("damage"):
		ENEMY_COLLISION = false

func _on_damage_collision_area_entered(area) -> void:
	floating = true
	if area.is_in_group("float"):
		position.y = 0
		position.x = 0


func _on_crouch_test_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("float"):
		position.y = 0
		position.x = 0
		_health_process(-5)
