extends Sprite2D
class_name Fadein

var timeTotal: float
var timer: float

func _ready():
	visible = false

func _process(delta):
	if timer > 0:
		timer -= delta
		modulate.a = timer/timeTotal
	pass

func setup(time: float):
	timeTotal = time
	timer = time
	visible = true
	pass
