extends Node2D
@onready var growing: bool = true
func _summoned(initial_size: Vector2, size_growth: Vector2, size_growth_speed: float, direction: float, parent):
	$CharacterBody2D.call_deferred("_summoned", initial_size, size_growth, size_growth_speed, direction, parent)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
