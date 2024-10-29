extends Button
class_name FloatOnHoverButton

var FLOAT_DISTANCE: float = 2
var LERP_DISTANCE: float = 1
var LERP_SPEED: float = 2
var direction: int = 1
var origin: Vector2

func _ready():
	origin = position

func _process(delta):
	if is_hovered():
		if  abs(position.y - (origin.y + FLOAT_DISTANCE)) < LERP_DISTANCE :
			direction = -1
		elif abs(position.y - (origin.y - FLOAT_DISTANCE)) < LERP_DISTANCE :
			direction = 1
		position.y = lerpf(position.y, origin.y + (direction * FLOAT_DISTANCE), LERP_SPEED * delta)
	else:
		position.y = lerpf(position.y, origin.y, LERP_SPEED * delta)
	pass
