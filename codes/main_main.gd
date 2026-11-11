extends Node2D
var START_TIME: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var SAVE_ACCESS_1 = FileAccess.open("user://save_1.save", FileAccess.READ)
	var SAVE_ACCESS_2 = FileAccess.open("user://save_2.save", FileAccess.READ)
	var SAVE_ACCESS_3 = FileAccess.open("user://save_3.save", FileAccess.READ)
	var DATA_1 = SAVE_ACCESS_1.get_var()
	var DATA_2 = SAVE_ACCESS_2.get_var()
	var DATA_3 = SAVE_ACCESS_3.get_var()
	DATA_1.hour = int(DATA_1.play_time / 360000)
	DATA_1.minute = int(DATA_1.play_time / 60000 - DATA_1.hour * 60)
	DATA_2.hour = int(DATA_2.play_time / 360000)
	DATA_2.minute = int(DATA_2.play_time / 60000 - DATA_2.hour * 60)
	DATA_3.hour = int(DATA_3.play_time / 360000)
	DATA_3.minute = int(DATA_3.play_time / 60000 - DATA_3.hour * 60)
	var extra_zero = "0%s"
	var extra_extra_zero = "00%s"
	if DATA_1.minute < 10:
		DATA_1.minute  = extra_zero % [DATA_1.minute]
	if DATA_2.minute < 10:
		DATA_2.minute  = extra_zero % [DATA_2.minute]
	if DATA_3.minute < 10:
		DATA_3.minute  = extra_zero % [DATA_3.minute]
	if DATA_1.hour < 10:
		DATA_1.hour = extra_extra_zero % [DATA_1.hour]
	else:
		if DATA_1.hour < 100:
			DATA_1.hour = extra_zero % [DATA_1.hour]
	if DATA_2.hour < 10:
		DATA_2.hour = extra_extra_zero % [DATA_2.hour]
	else:
		if DATA_2.hour < 100:
			DATA_2.hour = extra_zero % [DATA_2.hour]
	if DATA_3.hour < 10:
		DATA_3.hour = extra_extra_zero % [DATA_3.hour]
	else:
		if DATA_3.hour < 100:
			DATA_3.hour = extra_zero % [DATA_3.hour]
	var time_format = "%s:%s"
	var time_1_display = time_format % [DATA_1.hour, DATA_1.minute]
	var time_2_display = time_format % [DATA_2.hour, DATA_2.minute]
	var time_3_display = time_format % [DATA_3.hour, DATA_3.minute]
	$Node2D2/Camera2D/Control/BoxContainer2/TextureButton4/Label.text = time_1_display
	$Node2D2/Camera2D/Control/BoxContainer2/TextureButton4/Label2.text = DATA_1.place
	$Node2D2/Camera2D/Control/BoxContainer2/TextureButton4/Label3.text = DATA_1.enemy
	$Node2D2/Camera2D/Control/BoxContainer2/TextureButton5/Label.text = time_2_display
	$Node2D2/Camera2D/Control/BoxContainer2/TextureButton5/Label2.text = DATA_2.place
	$Node2D2/Camera2D/Control/BoxContainer2/TextureButton5/Label3.text = DATA_2.enemy
	$Node2D2/Camera2D/Control/BoxContainer2/TextureButton6/Label.text = time_3_display
	$Node2D2/Camera2D/Control/BoxContainer2/TextureButton6/Label2.text = DATA_3.place
	$Node2D2/Camera2D/Control/BoxContainer2/TextureButton6/Label3.text = DATA_3.enemy
func _pause():
	get_tree().paused = true
	Autoloads.PAUSE = true
func _restart():
	get_tree().paused = false
	Autoloads.PAUSE = false
	$Node2D2/Player.call("_possess_revisible")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("j"):
		get_tree().paused = false
		Autoloads.PAUSE = false
	if Input.is_action_just_pressed("l"):
		$Node2D2/StaticBody2D._erase_enemy()
func _on_home_return_pressed() -> void:
	if $Node2D2/Camera2D/Control.FILE_OPEN:
		$Node2D2/Camera2D/Controlol.FILE_OPEN = false
	else:
		get_tree().paused = false
		if Autoloads.PLAYER_POSSESSING:
			$Node2D2/Player/Sprite2D.visible = true
			$Node2D2/Player/PlayerIndicator.visible = true
	Autoloads.CURRENT_STATE = "home"
	queue_free()
func _tutorial():
	$Node2D2/Camera2D/TextBox._text_open(0, true)
