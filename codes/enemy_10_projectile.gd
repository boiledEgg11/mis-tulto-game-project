extends Node2D
@onready var growing: bool = true
func _summoned(initial_size: Vector2, size_growth: float, direction: float):
	$CharacterBody2D.call_deferred("_summoned", initial_size, size_growth, direction)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
