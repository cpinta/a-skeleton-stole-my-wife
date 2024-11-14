extends CanvasLayer
class_name TitleScreen

var startButton: TouchScreenButton

signal startPressed(input: InputHandler.GameInput)

# Called when the node enters the scene tree for the first time.
func _ready():
	startButton = $Control/Centered/Control/TouchScreenButton
	startButton.released.connect(_start_touch)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		_start_keyboard()
	pass
	
func _start_touch():
	startPressed.emit(InputHandler.GameInput.TOUCH)
	pass

func _start_keyboard():
	startPressed.emit(InputHandler.GameInput.MOUSE)
	pass
