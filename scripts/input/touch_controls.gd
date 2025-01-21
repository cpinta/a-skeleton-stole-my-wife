extends CanvasLayer
class_name TouchControls

var btnInteract: TouchScreenButton
var btnDrop: TouchScreenButton
var btnDash: TouchScreenButton

var moveJoystick: VirtualJoystick
var aimJoystick: VirtualJoystick

var moveVector: Vector2 = Vector2.ZERO

var aimTouchIndex: int = -1
var aimPosition: Vector2
var aimVector: Vector2 = Vector2(1, 0)	#DIRECTION AND MAGNITUDE! BOOYAH!

var lblDebug: Label

signal press_shoot_current_weapon
var current_weapon_pressed: bool = false
signal release_shoot_current_weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	btnInteract = $Control/buttons/interact/interact
	btnDrop = $Control/buttons/drop/drop
	btnDash = $Control/buttons/dash/dash
	moveJoystick = $"Control/move Virtual Joystick"
	aimJoystick = $"Control/aim Virtual Joystick"
	
	lblDebug = $debugLog
	lblDebug.visible = Game.debug
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if aimJoystick.is_pressed:
		aimVector = aimJoystick.output
		press_shoot_current_weapon.emit()
		current_weapon_pressed = true
	else:
		if current_weapon_pressed:
			release_shoot_current_weapon.emit()
			current_weapon_pressed = false
			pass
	
	moveVector = -moveJoystick.output
	pass

func _input(event: InputEvent) -> void:
	pass

func _reset():
	aimTouchIndex = -1
	pass

func _update_aim(position: Vector2):
	aimPosition = position
	if Game.player != null:
		aimVector = position - Game.player.global_position
	pass
