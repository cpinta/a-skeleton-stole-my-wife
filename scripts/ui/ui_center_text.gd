extends Label
class_name UI_CenterText

var timer: float = 0

var shakeStrength: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer > 0:
		timer -= delta
		position = Vector2.RIGHT.rotated(randf_range(0, 2*PI)) * shakeStrength
		pass
	else:
		visible = false
		pass
	pass

func set_center_text(txt: String, time: float, shakeStrength: float = 0):
	visible = true
	text = txt
	timer = time
	self.shakeStrength = shakeStrength
	pass
