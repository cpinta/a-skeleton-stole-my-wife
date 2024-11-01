extends Label
class_name Shaking_Label

var origin: Vector2
@export var SHAKE_STRENGTH: float = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	origin = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = origin + Vector2.RIGHT.rotated(randf_range(0, 2*PI)) * SHAKE_STRENGTH
	pass
