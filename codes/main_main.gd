extends Node2D
var START_TIME: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func _pause():
	get_tree().paused = true
	Autoloads.PAUSE = true
func _restart():
	get_tree().paused = false
	Autoloads.PAUSE = false
	$Node2D2/Player.call("_possess_revisible")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("j"):
		get_tree().paused = false
		Autoloads.PAUSE = false
	if Input.is_action_just_pressed("l"):
		get_tree().paused = true
		Autoloads.PAUSE = true


func _on_home_return_pressed() -> void:
	if $Node2D2/Player/Camera2D/Control.FILE_OPEN:
		$Node2D2/Player/Camera2D/Controlol.FILE_OPEN = false
	else:
		get_tree().paused = false
		if Autoloads.PLAYER_POSSESSING:
			$Node2D2/Player/Sprite2D.visible = true
			$Node2D2/Player/PlayerIndicator.visible = true
	Autoloads.CURRENT_STATE = "home"
	queue_free()
