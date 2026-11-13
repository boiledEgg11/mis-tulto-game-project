extends Node2D
@onready var projectile_number: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _erase():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	get_parent().get_parent().call("_projectile_erase", projectile_number)
