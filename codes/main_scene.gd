extends Node2D
var MAIN
var OPENED = false
var MODE = "new"
var START = false
# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if START:
		$Camera2D.enabled = false
	else:
		if OPENED:
			$Control/GameStarts.visible = false
			$Control/SaveFiles.visible = true
			$Control/Return.visible = true
		if not OPENED:
			$Control/GameStarts.visible = true
			$Control/SaveFiles.visible = false
			$Control/Return.visible = false
func _on_new_game_pressed() -> void:
	OPENED = true
	MODE = "new"
func _on_continue_pressed() -> void:
	OPENED = true
	MODE = "continue"


func _on_save_file_1_pressed() -> void:
	pass # Replace with function body.


func _on_save_file_2_pressed() -> void:
	pass # Replace with function body.


func _on_save_file_3_pressed() -> void:
	pass # Replace with function body.


func _on_return_pressed() -> void:
	OPENED = false
