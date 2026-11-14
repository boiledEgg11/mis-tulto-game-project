extends Node2D
@onready var projectile_number: int
@onready var location
@onready var parent
@onready var released = false
@onready var target_pos: Vector2
@onready var moving = false
@onready var target_touched = false
@onready var rotated = 0
@onready var target_position: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
func _erase():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Node2D/CharacterBody2D.move_and_slide()
	if Input.is_action_just_pressed("8"):
		_pos_reset()
	if Input.is_action_just_pressed("9"):
		_fly(Vector2(0, 0))
	if target_touched:
		$Node2D/CharacterBody2D.global_position.x = move_toward(global_position.x, target_position.x, 10)
		$Node2D/CharacterBody2D.global_position.y = move_toward(global_position.y, target_position.y, 10)
	if moving:
		if not $Node2D/CharacterBody2D/RayCast2D.is_colliding():
			$Node2D.rotation_degrees += 7.5
		if $Node2D/CharacterBody2D/RayCast2D.is_colliding():
			target_position = $Node2D/CharacterBody2D/RayCast2D.get_collision_point()
			moving = false
			print("touched!")
			target_touched = true
	if not $Node2D/CharacterBody2D/VisibleOnScreenNotifier2D.is_on_screen() and get_parent() != Autoloads.center:
		await get_tree().process_frame
		if not $Node2D/CharacterBody2D/VisibleOnScreenNotifier2D.is_on_screen() and get_parent() != Autoloads.center:
			_screen_not_visible()
func _screen_not_visible():
	reparent(parent)
	print("removal")
	get_parent().get_parent().call("_projectile_erase", projectile_number)
func _fly(target: Vector2):
	moving = true
	location = global_position
	position = Vector2(0, 0)
	rotated = global_rotation
	released  = true
	reparent(Autoloads.center)
	rotation = rotated
	global_position = location
	target_pos = target
func _pos_reset():
	position = Vector2(0, 0)
	get_child(0)
