extends Node2D
@onready var bar_move: bool =false 
func _erase():
	queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if i is TileMapLayer:
			Autoloads.tiles.append(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bar_move:
		$TileMapLayer4.position.y += 4
		if $TileMapLayer4.position.y == 0:
			bar_move = false
func _raid_start():
	Autoloads.player.call_deferred("_raid", "test_level_4")
func _on_enemy_raid_start_body_entered(body: Node2D) -> void:
	_raid_start()
	bar_move = true


func _on_enemy_raid_start_body_exited(body: Node2D) -> void:
	Autoloads.player.call_deferred("_raid_end")
