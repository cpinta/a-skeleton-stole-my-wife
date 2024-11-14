extends Control
class_name DeathScreen

enum GrimAnimState {SKULL_APPEARING, RAISE_HAND1, RAISE_HAND2, COMPLETE}

var state: GrimAnimState

var body: AnimatedSprite2D
var talkText: Label

var lhand: AnimatedSprite2D
var rhand: AnimatedSprite2D
var HAND_START_YOFFSET: int = 60
var HAND_RAISE_SPEED: float = 40

var btnTryAgain: Button
var btnTryAgainOrigin: Vector2
var SHAKE_STRENGTH_TRYAGAIN: float = 1
var btnTryAgainTouch: TouchScreenButton

var btnQuit: Button
var btnQuitOrigin: Vector2
var SHAKE_STRENGTH_QUIT: float = 6
var btnQuitTouch: TouchScreenButton

signal tryagain
signal quitgame

func _ready():
	body = $body
	body.play("intro")
	body.connect("animation_finished", anim_done)
	
	talkText = $talking
	
	lhand = $"body/left arm"
	rhand = $"body/right arm"
	btnTryAgain = $"body/left arm/tryagain"
	btnTryAgainTouch = btnTryAgain.get_node("Control/TouchScreenButton")
	
	btnQuit = $"body/right arm/quit"
	btnQuitTouch = btnQuit.get_node("Control/TouchScreenButton")
	
	lhand.position.y = HAND_START_YOFFSET
	rhand.position.y = HAND_START_YOFFSET
	
	btnTryAgain.visible = false 
	btnQuit.visible = false
	
	btnTryAgain.pressed.connect(try_again)
	btnTryAgainTouch.released.connect(try_again)
	btnQuit.pressed.connect(quit)
	btnQuitTouch.released.connect(quit)
	
	btnTryAgainOrigin = btnTryAgain.position
	btnQuitOrigin = btnQuit.position
	change_state(GrimAnimState.SKULL_APPEARING)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		GrimAnimState.SKULL_APPEARING:
			pass
		GrimAnimState.RAISE_HAND1:
			if rhand.position.y > 0:
				rhand.position.y -= HAND_RAISE_SPEED * delta
			else:
				change_state(GrimAnimState.RAISE_HAND2)
			pass
		GrimAnimState.RAISE_HAND2:
			if lhand.position.y > 0:
				lhand.position.y -= HAND_RAISE_SPEED * delta
			else:
				change_state(GrimAnimState.COMPLETE)
			pass
		GrimAnimState.COMPLETE:
			pass
			
	if btnTryAgain.is_hovered():
		btnTryAgain.position = btnTryAgainOrigin + Vector2.RIGHT.rotated(randf_range(0, 2*PI)) * SHAKE_STRENGTH_TRYAGAIN
	if btnQuit.is_hovered():
		btnQuit.position = btnQuitOrigin + Vector2.RIGHT.rotated(randf_range(0, 2*PI)) * SHAKE_STRENGTH_QUIT
	pass
	
func change_state(newState: GrimAnimState):
	state = newState
	match state:
		GrimAnimState.SKULL_APPEARING:
			talkText.text = "your circumstance seems grim."
			pass
		GrimAnimState.RAISE_HAND1:
			pass
		GrimAnimState.RAISE_HAND2:
			btnQuit.visible = true
			rhand.position.y = 0
			pass
		GrimAnimState.COMPLETE:
			talkText.text += "\nlet me cut you a deal."
			lhand.position.y = 0
			rhand.position.y = 0
			btnTryAgain.visible = true
			pass
	pass
	
func try_again():
	tryagain.emit()
	pass
	
func quit():
	quitgame.emit()
	pass

func anim_done():
	var animName: String = body.animation.get_basename()
	if animName == "intro":
		change_state(GrimAnimState.RAISE_HAND1)
		pass
