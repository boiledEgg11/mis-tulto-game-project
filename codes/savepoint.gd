extends StaticBody2D
var location
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _save():
	print("saved!")
	var SAVE_STUFF = {"place": location}
	print(SAVE_STUFF)
