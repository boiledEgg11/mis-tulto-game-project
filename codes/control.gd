extends Control
var FILE_OPEN = false
@onready var Test: Dictionary = {
	
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("3"):
		print(Autoloads.SAVE_STUFF.progression_stage.raid_3)
		Autoloads.SAVE_STUFF.progression_stage.raid_3 = true
	if Autoloads.SAVE_SCREEN and FILE_OPEN:
		$BoxContainer2.visible = true
		
	else:
		$BoxContainer2.visible = false
	if Autoloads.SAVE_SCREEN and not FILE_OPEN:
		$BoxContainer.visible = true
	else:
		$BoxContainer.visible = false
	if Autoloads.SAVE_SCREEN:
		$BoxContainer3.visible = true
	else:
		$BoxContainer3.visible = false
