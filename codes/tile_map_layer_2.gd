extends TileMapLayer
var pos = Vector2i(5,4)
var tiles
func _on_extra_attack_body_shape_entered(body_rid, _body, _body_shape_index: int, _local_shape_index: int) -> void:
	tiles = get_coords_for_body_rid(body_rid)
	erase_cell(tiles)
	print(tiles)
