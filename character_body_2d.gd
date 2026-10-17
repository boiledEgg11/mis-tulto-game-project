extends CharacterBody2D
var SPEED = 120.0
var JUMP_VELOCITY = -400.0
var DASHING = false
const DASH_TIME = 3
const DASH_SPEED = 480
var direction = 1
var health = 10
var ENEMY_COLLISION = false
var DAMAGE = 0
var DASH_COOL = false
var DASH_Y_CHANGE = 0
var CROUCH = false
var SLIDE = 0
var DASH_DIRECTION = 0
var DASH_MOVE = false
func _ready() -> void:
	pass
func _health_process() -> void:
	$PlayerHealth.value += DAMAGE
	if $PlayerHealth.value <= 0:
		_death()
func _death():
	pass
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
		else:
			if CROUCH:
				SLIDE = 120
			else:
				SLIDE = 30
		if not is_on_floor():
			if Input.is_action_pressed("down"):
				velocity += get_gravity() * delta * 2.5
			else:
				velocity += get_gravity() * delta * 1.5
		if CROUCH:
			SPEED = 30
			$Player_Shape.shape.size = Vector2(15.5, 7.75)
			$Player_Shape.position = Vector2(0, 3.875)
			$Area2D/PlayerAttackCollision.shape.size = Vector2(5, 2.5)
			$Area2D/PlayerAttackCollision.position = Vector2(0, 3.875)
			$Sprite2D.texture = load("res://assets/placeholder_player_crouch.png")
		if not CROUCH:
			SPEED = 120
			$Player_Shape.shape.size = Vector2(15.5, 15.5)
			$Player_Shape.position = Vector2(0, 0)
			$Area2D/PlayerAttackCollision.shape.size = Vector2(5, 5)
			$Area2D/PlayerAttackCollision.position = Vector2(0, 0)
			$Sprite2D.texture = load("res://assets/placeholder_player.png")
		if is_on_floor():
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
		if $DashRecover.value == 60 and direction != 0:
			if Input.is_action_just_pressed("space"): 
				if direction < 0:
					DASH_DIRECTION = -1
				if direction > 0:
					DASH_DIRECTION = 1
				DASH_MOVE = true
				print(direction)
				$DashRecover.value = 0
				velocity.y = DASH_Y_CHANGE * DASH_SPEED / 3
				velocity.x = (DASH_SPEED - abs(velocity.y)) * DASH_DIRECTION
				await get_tree().create_timer(0.25).timeout
				DASH_Y_CHANGE = 0
				DASH_MOVE = false
				velocity.x = 0
				velocity.y = 0
func _process(delta: float) -> void:
	_dash_recover_process(1)
func _dash_recover_process(delta:float) -> void:
	$DashRecover.value += delta * 1
