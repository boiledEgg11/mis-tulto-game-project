extends Node2D
@onready var bar_move_state: int = 0
func _erase():
	queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if i is TileMapLayer:
			Autoloads.tiles.append(i)
func _process(delta: float) -> void:
	if bar_move_state == 1:
		$TileMapLayer4.position.y += 4
		if $TileMapLayer4.position.y == 0:
			bar_move_state = 0
	if bar_move_state == 2:
		$TileMapLayer4.position.y -= 4
		if $TileMapLayer4.position.y == -80:
			bar_move_state = 0
func _raid_start():
	Autoloads.player.call_deferred("_raid", "test_level_4")
func _on_enemy_raid_start_body_entered(body: Node2D) -> void:
	_raid_start()
	bar_move_state = 1
func _raid_end():
	bar_move_state = 2

func _on_enemy_raid_start_body_exited(body: Node2D) -> void:
	Autoloads.player.call_deferred("_raid_end")
