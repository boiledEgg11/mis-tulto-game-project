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
		if $TileMapLayer4.position.y >= 0:
			bar_move_state = 0
			return
		$TileMapLayer4.position.y += 4
	if bar_move_state == 2:
		if $TileMapLayer4.position.y <=-80:
			bar_move_state = 0
			return
		$TileMapLayer4.position.y -= 4
	if Progressions.progression.raid_1:
		if not $EnemyRaidStart/CollisionShape2D.disabled:
			$EnemyRaidStart/CollisionShape2D.disabled = true
			$Area2D/Sprite2D.visible = false
func _raid_start():
	Autoloads.player.call_deferred("_raid", "test_level_4", self)
	await get_tree().create_timer(0.5).timeout
	$Area2D/Sprite2D.visible = false
func _on_enemy_raid_start_body_entered(body: Node2D) -> void:
	_raid_start()
	bar_move_state = 1
func _raid_end():
	bar_move_state = 2
	$EnemyRaidStart/CollisionShape2D.disabled = true
	Progressions.progression.raid_1 = true
func _on_enemy_raid_start_body_exited(body: Node2D) -> void:
	Autoloads.player.call_deferred("_raid_end")
