extends InputMethod
class_name Touch

var circle_container
var circles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	circle_container = $"circle container"
	for circle in circle_container.get_children():
		circles.append(circle)
	pass # Replace with function body.

func _input(event):
	if event is InputEventScreenDrag:
		var i = event.index
		if i < circles.size():
			circles[i].show()
			circles[i].global_position = event.position
		pass
	if event is InputEventScreenTouch and not event.pressed:
		var i = event.index
		circles[i].hide()
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
