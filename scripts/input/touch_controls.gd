extends CanvasLayer
class_name TouchControls

var btnInteract: TouchScreenButton
var btnDrop: TouchScreenButton
var btnDash: TouchScreenButton

var moveJoystick: VirtualJoystick
var aimJoystick: VirtualJoystick

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
	
	#btnInteract.pressed.connect(interact_button_pressed)
	#btnDrop.pressed.connect(drop_button_pressed)
	#btnDash.pressed.connect(dash_button_pressed)
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
	pass

func _input(event: InputEvent) -> void:
	pass
	#if event is InputEventScreenTouch:
		#if event.pressed:
			#if not moveJoystick._is_point_inside_joystick_area(event.position) and aimTouchIndex == -1 and event.index != moveJoystick._touch_index:
				#lblDebug.text += "touched\n"
				#aimTouchIndex = event.index
				#_update_aim(event.position)
				#pass
		#elif event.index == aimTouchIndex:
			#_reset()
			#get_viewport().set_input_as_handled()
	#elif event is InputEventScreenDrag:
		#if event.index == aimTouchIndex:
			#_update_aim(event.position)
			#get_viewport().set_input_as_handled()

func _reset():
	aimTouchIndex = -1
	pass

func _update_aim(position: Vector2):
	aimPosition = position
	if Game.player != null:
		aimVector = position - Game.player.global_position
	pass
