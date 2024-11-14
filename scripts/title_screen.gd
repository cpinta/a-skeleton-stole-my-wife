extends CanvasLayer
class_name TitleScreen

var startButton: TouchScreenButton

signal startPressed

# Called when the node enters the scene tree for the first time.
func _ready():
	startButton.released.connect(_start)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		_start()
	pass

func _start():
	startPressed.emit()
	pass
