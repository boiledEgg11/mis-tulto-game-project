extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _pause():
	get_tree().paused = true
	Autoloads.PAUSE = true
func _restart():
	get_tree().paused = false
	Autoloads.PAUSE = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("j"):
		get_tree().paused = false
		Autoloads.PAUSE = false
	if Input.is_action_just_pressed("l"):
		get_tree().paused = true
		Autoloads.PAUSE = true
