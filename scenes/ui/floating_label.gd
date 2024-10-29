extends Label
class_name Floating_Label

@export var BOB_RANGE: float = 6
var BOB_RANGE_HALF: float
@export var LERP_SPEED: float = 0.5
@export var LERP_MIN_DISTANCE: float = 1
var direction: int = 1
var intialPos: Vector2

func _ready():
	intialPos = position
	BOB_RANGE_HALF = BOB_RANGE/2
	pass
	
func _process(delta):
	if abs(position.y - (intialPos.y + BOB_RANGE_HALF)) < LERP_MIN_DISTANCE :
		direction = -1
	elif abs(position.y - (intialPos.y - BOB_RANGE_HALF)) < LERP_MIN_DISTANCE :
		direction = 1
	position.y = lerpf(position.y, intialPos.y + (direction * BOB_RANGE_HALF), LERP_SPEED * delta)
	pass
