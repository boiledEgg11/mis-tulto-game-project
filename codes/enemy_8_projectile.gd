extends Node2D
@onready var projectile_number: int
@onready var location
@onready var parent
@onready var released = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
func _erase():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("9"):
		_fly(Vector2(0, 0))
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	reparent(parent)
	print("removal")
	get_parent().get_parent().call("_projectile_erase", projectile_number)
func _fly(target: Vector2):
	released  = true
	reparent(Autoloads.center)
	
