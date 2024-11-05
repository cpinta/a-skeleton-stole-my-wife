extends CanvasLayer
class_name TouchControls

var btnInteract: TouchScreenButton
var btnDrop: TouchScreenButton
var btnDash: TouchScreenButton

var joystick: VirtualJoystick

# Called when the node enters the scene tree for the first time.
func _ready():
	btnInteract = $Control/buttons/interact/interact
	btnDrop = $Control/buttons/drop/drop
	btnDash = $Control/buttons/dash/dash
	#joystick = $MultidirectionnalJoystick
	
	#btnInteract.pressed.connect(interact_button_pressed)
	#btnDrop.pressed.connect(drop_button_pressed)
	#btnDash.pressed.connect(dash_button_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
