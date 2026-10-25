extends TileMapLayer
var pos = Vector2i(5,4)
var tiles
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.



func _on_area_2d_area_entered(area) -> void:
	pass


func _on_extra_attack_body_shape_entered(body_rid, body, body_shape_index: int, local_shape_index: int) -> void:
	tiles = get_coords_for_body_rid(body_rid)
	erase_cell(tiles)
	print(tiles)
