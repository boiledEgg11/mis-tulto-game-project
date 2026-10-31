extends Area2D
var speed = 120
var direction = 1
var MOVING = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if MOVING:
		if direction != 0:
			if not $VisibleOnScreenNotifier2D.is_on_screen():
				queue_free()
		position.y+= speed * delta
func _on_body_entered(_body) -> void:
	MOVING = false
	$CollisionShape2D.shape.radius = 32
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.shape.radius = 8
	queue_free()
