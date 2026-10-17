extends CharacterBody2D
var SPEED = 120.0
var JUMP_VELOCITY = -400.0
var DASHING = false
const DASH_TIME = 3
const DASH_SPEED = 480
var direction = 1
var health = 10
var ENEMY_COLLISION = false
var DASH_COOL = false
var DASH_Y_CHANGE = 0
var CROUCH = false
var SLIDE = 0
var DASH_DIRECTION = 0
var DASH_MOVE = false
var DAMAGE_MULTIPLIER = 1
var CROUCH_BLOCK = false
func _ready() -> void:
	$CrouchTestArea/CollisionShape2D.shape.size = Vector2(15.5, 15.5)
	$PlayerHealth.value = 10
func _health_process(DAMAGE: float) -> void:
	$PlayerHealth.value += DAMAGE * DAMAGE_MULTIPLIER
	if $PlayerHealth.value <= 0:
		_death()
func _death():
	print("dead!")
	await get_tree().create_timer(1).timeout
	$PlayerHealth.value = 10
func _physics_process(delta: float) -> void: 
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
		if not is_on_floor():
			if Input.is_action_pressed("down"):
				velocity += get_gravity() * delta * 2.5
			else:
				velocity += get_gravity() * delta * 1.5
		if CROUCH:
			SPEED = 30
			$Player_Shape.shape.size = Vector2(15.5, 7.75)
			$Player_Shape.position = Vector2(0, 3.875)
			$AttackCollisionArea/PlayerAttackCollision.shape.size = Vector2(14, 7)
			$AttackCollisionArea/PlayerAttackCollision.position = Vector2(0, 3.875)
			$Sprite2D.texture = load("res://assets/placeholder_player_crouch.png")
		if not CROUCH:
			SPEED = 120
			$Player_Shape.shape.size = Vector2(15.5, 15.5)
			$Player_Shape.position = Vector2(0, 0)
			$AttackCollisionArea/PlayerAttackCollision.shape.size = Vector2(14, 14)
			$AttackCollisionArea/PlayerAttackCollision.position = Vector2(0, 0)
			$Sprite2D.texture = load("res://assets/placeholder_player.png")
		if is_on_floor():
			if not CROUCH_BLOCK:
				if Input.is_action_pressed("down"):
					CROUCH = true
				else:
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
				$DashRecover.value = 0
				if direction == 0:
					velocity.x = 0
					if DASH_Y_CHANGE == 1:
						velocity.y = DASH_Y_CHANGE * DASH_SPEED
					else:
						velocity.y = DASH_Y_CHANGE * DASH_SPEED / 1.5
				else:
					velocity.y = DASH_Y_CHANGE * DASH_SPEED / 3
					velocity.x = abs(DASH_SPEED - abs(velocity.y)) * DASH_DIRECTION
				await get_tree().create_timer(0.25).timeout
				DASH_Y_CHANGE = 0
				DASH_MOVE = false
				velocity.x = 0
				velocity.y = 0
func _process(delta: float) -> void:
	_dash_recover_process(1)
	if Input.is_action_just_pressed("i"):
		_health_process(-1)
func _dash_recover_process(delta:float) -> void:
	$DashRecover.value += delta * 1


func _on_crouch_test_area_body_shape_entered(body_rid: RID, body: TileMapLayer, body_shape_index: int, local_shape_index: int) -> void:
	CROUCH_BLOCK = true
	print("cant crouch")
	CROUCH = true


func _on_crouch_test_area_body_shape_exited(body_rid: RID, body: TileMapLayer, body_shape_index: int, local_shape_index: int) -> void:
	CROUCH_BLOCK = false
	print("can crouch") 
