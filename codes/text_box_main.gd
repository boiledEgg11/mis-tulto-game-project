extends Control
@onready var textbox_visible = false
@onready var current_text = 0
@onready var text_file = FileAccess.open("res://assets/text/test_text.txt", FileAccess.READ)
@onready var text_line
@onready var line_is_special = false
func _cycle_text():
	current_text += 1
	print("next text!")
	_text_open()
func _close_text():
	$TextureButton.visible = false
	current_text += 1
func _normal_text_call(text_num):
	print(text_num)
	match text_line[text_num]:
		"text_break":
			_close_text()
		"normal_line":
			line_is_special = false
			_cycle_text()
		"special_line":
			line_is_special = true
			_cycle_text()
		_:
			$TextureButton.texture_normal = load("res://assets/sprites/textbox_ui.png")
			$TextureButton.texture_hover = load("res://assets/sprites/textbox_selected_ui.png")
			$TextureButton.texture_pressed = load("res://assets/sprites/textbox_pressed_ui.png")
			$TextureButton/RichTextLabel.text = str(text_line[text_num])
	current_text = text_num
func _special_text_call(text_num):
	print(text_num)
	match text_line[text_num]:
		"text_break":
			_close_text()
		"normal_line":
			current_text += 1
			line_is_special = false
			_cycle_text()
		"special_line":
			current_text += 1
			line_is_special = true
			_cycle_text()
		_:
			$TextureButton.texture_normal = load("res://assets/sprites/textbox_special_ui.png")
			$TextureButton.texture_hover = load("res://assets/sprites/textbox_special_selected_ui.png")
			$TextureButton.texture_pressed = load("res://assets/sprites/textbox_special_pressed_ui.png")
			$TextureButton/RichTextLabel.text = str(text_line[text_num])
	current_text = text_num
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("j"):
		_text_open()
	if Input.is_action_just_pressed("i"):
		_close_text()
func _on_texture_button_pressed() -> void:
	_cycle_text()
func _ready() -> void:
	$TextureButton.visible = false
	_text_load(text_file)
func _text_load(open_file):
	var file_content = text_file.get_as_text()
	text_file.close()
	text_line = file_content.split("\n")
func _text_open():
	$TextureButton.visible = true
	if line_is_special:
		print("special line!")
		_special_text_call(current_text)
	if not line_is_special:
		_normal_text_call(current_text)
