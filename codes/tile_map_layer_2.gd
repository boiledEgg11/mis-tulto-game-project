extends TileMapLayer
var pos = Vector2i(5,4)
var tiles
func _on_extra_attack_body_shape_entered(body_rid, body, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.is_in_group("tile_breakable"):
		tiles = get_coords_for_body_rid(body_rid)
		erase_cell(tiles)


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("tile_breakable"):
		tiles = get_coords_for_body_rid(body_rid)
		erase_cell(tiles)
