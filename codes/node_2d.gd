extends Node2D
var save
var save_info
var bodies

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bodies = $Node2D/Player/ExtraAttack.get_overlapping_bodies()
	for body in bodies:
		if not body.is_in_group("tile_breakable"):
				break
		var a = $TileMapLayer2.get_cell_atlas_coords(body.position)
		$TileMapLayer2.erase_cell(body.local_to_map($TileMapLayer2.get_local_mouse_position()))
		print(a)
