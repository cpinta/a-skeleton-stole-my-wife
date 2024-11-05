extends Node2D
class_name InputHandler

enum GameInput {MOUSE=0, TOUCH=1}

var curInputMethod: GameInput

var inputVector: Vector2

var touchScene: PackedScene
var touchUI: TouchControls

signal inputDash
signal inputInteract
signal inputDrop
signal inputShootPressed(hand: Player.HandToUse)
signal inputShootReleased(hand: Player.HandToUse)
# Called when the node enters the scene tree for the first time.
func _ready():
	touchScene = load("res://scripts/input/touch_controls.tscn")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match curInputMethod:
		GameInput.MOUSE:
			if Input.is_action_pressed("jump"):
				pass
			if Input.is_action_just_pressed("dash"):
				input_dash()
				#dash()
				pass
			if Input.is_action_just_pressed("shoot_left"):
				shoot_pressed(Player.HandToUse.LEFT)
				#use_weapon(HandToUse.LEFT)
			if Input.is_action_just_released("shoot_left"):
				shoot_released(Player.HandToUse.LEFT)
				#stop_use_weapon(HandToUse.LEFT)
			if Input.is_action_just_pressed("shoot_right"):
				shoot_pressed(Player.HandToUse.RIGHT)
				#use_weapon(HandToUse.RIGHT)
			if Input.is_action_just_released("shoot_right"):
				shoot_released(Player.HandToUse.RIGHT)
				#stop_use_weapon(HandToUse.RIGHT)
			if Input.is_action_just_released("interact"):
				input_interact()
				#interact()
			if Input.is_action_just_released("drop"):
				input_drop()
				#drop_key()
			pass
		GameInput.TOUCH:
			pass
	pass
	
func input_drop():
	inputDrop.emit()
func input_interact():
	inputInteract.emit()
func input_dash():
	inputDash.emit()
func shoot_pressed(hand: Player.HandToUse):
	inputShootPressed.emit(hand)
func shoot_released(hand: Player.HandToUse):
	inputShootReleased.emit(hand)
	
	

func load_controls():
	match curInputMethod:
		GameInput.MOUSE:
			pass
		GameInput.TOUCH:
			load_touch_controls()
			#touchUI.joystick.joystick_change.connect(touch_joystick_change)
			touchUI.btnDash.released.connect(input_dash)
			touchUI.btnInteract.released.connect(input_interact)
			touchUI.btnDrop.released.connect(input_drop)
			pass
	pass
	
func unload_controls():
	match curInputMethod:
		GameInput.MOUSE:
			pass
		GameInput.TOUCH:
			unload_touch_controls()
			pass
	pass

func set_input_method(newInput: GameInput):
	curInputMethod = newInput
	match curInputMethod:
		GameInput.MOUSE:
			unload_touch_controls()
			pass
		GameInput.TOUCH:
			load_touch_controls()
			pass
	load_controls()
	pass
	
func get_aim_point():
	match curInputMethod:
		GameInput.MOUSE:
			return get_global_mouse_position()
			pass
		GameInput.TOUCH:
			return Vector2.ZERO
			pass
	pass
	
func get_inputVector():
	inputVector = Vector2.ZERO
	if Input.is_action_pressed("left"):
		inputVector.x += 1
	if Input.is_action_pressed("right"):
		inputVector.x -= 1
	if Input.is_action_pressed("up"):
		inputVector.y += 1
	if Input.is_action_pressed("down"):
		inputVector.y -= 1
	return inputVector
	pass
	
func touch_joystick_change(vector: Vector2):
	if curInputMethod == GameInput.TOUCH:
		inputVector = vector
	pass
	
func get_inputVector_relative_to_point(vector: Vector2):
	match curInputMethod:
		GameInput.MOUSE:
			pass
		GameInput.TOUCH:
			pass
	pass

func load_touch_controls():
	if touchUI == null:
		touchUI = touchScene.instantiate() as TouchControls
		self.add_child(touchUI)
	pass
	
func unload_touch_controls():
	if touchUI != null:
		touchUI.queue_free()
	pass