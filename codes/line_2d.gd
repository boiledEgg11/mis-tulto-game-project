extends Line2D

var new_shape
var rect
var length
var attack = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in points.size() - 1:
		new_shape = $Area2D/CollisionShape2D
		$Area2D.add_child(new_shape)
		rect = RectangleShape2D.new()
		new_shape.position = (points[i] + points[i + 1]) / 2
		new_shape.rotation = points[i].direction_to(points[i + 1]).angle()
		length = points[i].distance_to(points[i + 1])
		rect.extents = Vector2(length, 10)
		new_shape.shape = rect
func _process(delta: float) -> void:
	if attack:
		$Area2D.add_to_group("damage")
	if not attack:
		$Area2D.remove_from_group("damage")
	for i in points.size() - 1:
		new_shape.position = (points[i] + points[i + 1]) / 2
		new_shape.rotation = points[i].direction_to(points[i + 1]).angle()
		length = points[i].distance_to(points[i + 1])
		rect.extents = Vector2(length /2 , 10)
		new_shape.shape = rect
