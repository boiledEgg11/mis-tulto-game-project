extends Control
var FILE_OPEN = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_tree().paused and Input.is_action_just_pressed("l"):
		get_tree().paused = false
		Autoloads.PAUSE = false
		print(get_tree().paused)
		$BoxContainer.visible = false
		print("pause end")
	if FILE_OPEN:
		$BoxContainer2.visible = true
		
	else:
		$BoxContainer2.visible = false
	if get_tree().paused and not FILE_OPEN:
		$BoxContainer.visible = true
	else:
		$BoxContainer.visible = false
	if not get_tree().paused and Input.is_action_just_pressed("l"):
		get_tree().paused = true
		$BoxContainer.visible = true
