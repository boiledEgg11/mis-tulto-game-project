extends StaticBody2D
var location
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _save(enemy):
	var parent = get_parent()
	parent.call("_save", enemy)
