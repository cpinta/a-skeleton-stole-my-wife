extends Sprite2D
class_name Intro_SkeleBack

var startY: float = 40
var endY: float = 18
var startScale: float = 1
var endScale: float = 0.8

var totalTime: float
var timer: float = 0

func _ready():
	pass
	
func _process(delta):
	if timer > 0:
		position = Vector2(position.x, endY - (timer/totalTime * (endY - startY)))
		scale = Vector2.ONE * (endScale - (timer/totalTime * (endScale - startScale)))
		timer -= delta
	pass
	
func setup(time:float):
	totalTime = time
	timer = time
	scale = Vector2.ONE * startScale
