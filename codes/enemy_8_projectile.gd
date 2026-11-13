extends Node2D
@onready var projectile_number: int
@onready var location
@onready var parent
@onready var released = false
@onready var target_pos: Vector2
@onready var moving = false
@onready var target_reached = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
func _erase():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("8"):
		_pos_reset()
	if Input.is_action_just_pressed("9"):
		_fly(Vector2(0, 0))
	if target_reached:
		get_child(0).position.x = move_toward(get_child(0).position.x, 0, -1)
		get_child(0).position.y = move_toward(get_child(0).position.y, 0, -1)
	if moving:
		get_child(0).position.x = move_toward(get_child(0).position.x, 0, 1)
		get_child(0).position.y = move_toward(get_child(0).position.y, 0, 1)
		position.x = move_toward(global_position.x, target_pos.x, 5)
		position.y = move_toward(global_position.y, target_pos.y, 5)
		if global_position == target_pos:
			moving = false
			target_reached = true
	if not $VisibleOnScreenNotifier2D.is_on_screen():
		await get_tree().process_frame
		if not $VisibleOnScreenNotifier2D.is_on_screen():
			_screen_not_visible()
func _screen_not_visible():
	reparent(parent)
	print("removal")
	get_parent().get_parent().call("_projectile_erase", projectile_number)
func _fly(target: Vector2):
	moving = true
	location = global_position
	position = Vector2(0, 0)
	released  = true
	reparent(Autoloads.center)
	look_at(target)
	position = location
	target_pos = target
func _pos_reset():
	position = Vector2(0, 0)
	get_child(0).global_rotation_degrees = 0
