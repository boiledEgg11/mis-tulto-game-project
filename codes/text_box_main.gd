extends Control
@onready var textbox_visible = false
@onready var current_text = 0
@onready var text_file = FileAccess.open("res://assets/text/test_text.txt", FileAccess.READ)
@onready var text_line
@onready var line_is_special = false
@onready var max_line_length = 0
func _cycle_text(pause):
	current_text += 1
	_text_open(current_text, pause)
func _close_text():
	get_tree().paused = false
	$TextureButton.visible = false
	current_text += 1
func _normal_text_call(text_num, pause):
	if text_num < max_line_length:
		current_text = text_num
		print(text_num)
		match text_line[text_num]:
			"text_break":
				_close_text()
			"normal_line":
				line_is_special = false
				_cycle_text(pause)
			"special_line":
				line_is_special = true
				_cycle_text(pause)
			_:
				$TextureButton.texture_normal = load("res://assets/sprites/textbox_ui.png")
				$TextureButton.texture_hover = load("res://assets/sprites/textbox_selected_ui.png")
				$TextureButton.texture_pressed = load("res://assets/sprites/textbox_pressed_ui.png")
				$TextureButton/RichTextLabel.text = str(text_line[text_num])
	else:
		current_text = 0
		_text_open(current_text, pause)
func _special_text_call(text_num, pause):
	if text_num < max_line_length:
		current_text = text_num
		match text_line[text_num]:
			"text_break":
				_close_text()
			"normal_line":
				line_is_special = false
				_cycle_text(pause)
			"special_line":
				line_is_special = true
				_cycle_text(pause)
			_:
				$TextureButton.texture_normal = load("res://assets/sprites/textbox_special_ui.png")
				$TextureButton.texture_hover = load("res://assets/sprites/textbox_special_selected_ui.png")
				$TextureButton.texture_pressed = load("res://assets/sprites/textbox_special_pressed_ui.png")
				$TextureButton/RichTextLabel.text = str(text_line[text_num])
	else:
		current_text = 0
		_text_open(current_text, pause)
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("j"):
		_text_open(current_text, true)
	if Input.is_action_just_pressed("i"):
		_close_text()
	if Autoloads.RESET:
		_close_text()
		current_text = 0
func _on_texture_button_pressed() -> void:
	_cycle_text(false)
func _ready() -> void:
	$TextureButton.visible = false
	_text_load(text_file)
func _text_load(open_file):
	var file_content = text_file.get_as_text()
	text_file.close()
	text_line = file_content.split("\n")
	max_line_length = text_line.size()
func _text_open(text_selected, pause):
	if pause:
		get_tree().paused = true
	$TextureButton.visible = true
	if line_is_special:
		print("special line!")
		_special_text_call(text_selected, pause)
	if not line_is_special:
		_normal_text_call(text_selected, pause)
