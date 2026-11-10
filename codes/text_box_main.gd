extends Control
var textbox_visible = false
var current_text = 0
func _cycle_text():
	current_text += 1
func _normal_text_call(text_num):
	$TextureButton.texture_normal = load("res://assets/sprites/textbox_ui.png")
	$TextureButton.texture_hover = load("res://assets/sprites/textbox_selected_ui.png")
	$TextureButton.texture_pressed = load("res://assets/sprites/textbox_pressed_ui.png")
	$TextureButton/RichTextLabel.text = str(text_num)
	current_text = text_num
func _special_text_call(text_num):
	$TextureButton.texture_normal = load("res://assets/sprites/textbox_special_ui.png")
	$TextureButton.texture_hover = load("res://assets/sprites/textbox_special_selected_ui.png")
	$TextureButton.texture_pressed = load("res://assets/sprites/textbox_special_pressed_ui.png")
	$TextureButton/RichTextLabel.text = str(text_num)
	current_text = text_num
func _on_texture_button_pressed() -> void:
	_cycle_text()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("i"):
		_normal_text_call(0)
	if Input.is_action_just_pressed("j"):
		_special_text_call(1)
