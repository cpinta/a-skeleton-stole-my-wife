extends Control
class_name GenderSelectScreen

enum FadeState {IN=0, OUT=1}
enum GSSState {APPEARING, APPEARED, SELECTED, VERYWELL, LEAVING}

var state: GSSState

var lblText: Label
var textFadeState: FadeState
var eAnim: AnimatedSprite2D

var btnM: Button
var btnMOrigin: Vector2
var btnMtouch: TouchScreenButton

var btnF: Button
var btnFOrigin: Vector2
var btnFtouch: TouchScreenButton

var BTN_FLOAT_DISTANCE: float = 2
var BTN_LERP_SPEED: float = 1
var BTN_LERP_DISTANCE: float = 1
var btnDirection: int = 1

var BTNS_APPEAR_DELAY: float = 2
var btnsAppearTimer: float = 0
var textFading: bool = false
var textQueued: String = ""
var genderWasSelected: bool = false
var genderSelected: Player.Gender

var strExitSaying: String = "very well."
var exitSayingFadeOutDelay: float = 2
var exitSayingFadeOutTimer: float = 0

var audio: AudioStreamPlayer2D

signal selectionDone

func _ready():
	
	lblText = $text
	lblText.visible = false
	
	btnM = $m
	btnM.visible = false
	btnMOrigin = btnM.position
	btnM.pressed.connect(select_m)
	btnM.disabled = true
	btnMtouch = $m/Control/TouchScreenButton
	btnMtouch.released.connect(select_m)
	
	btnF = $f
	btnF.visible = false
	btnFOrigin = btnF.position
	btnF.pressed.connect(select_f)
	btnF.disabled = true
	btnFtouch = $f/Control/TouchScreenButton
	btnFtouch.released.connect(select_f)
	
	eAnim = $e
	eAnim.animation_finished.connect(anim_done)
	eAnim.play("reveal")
	
	audio = $audio
	audio.play()
	
	state = GSSState.APPEARING
	pass

func _process(delta):
	if textFadeState == FadeState.IN:
		if lblText.modulate.a < 1:
			lblText.modulate.a += delta
		else:
			lblText.modulate.a = 1
			if state == GSSState.LEAVING:
				set_text_fade_state(FadeState.OUT)
				pass
	else:
		if state != GSSState.LEAVING:
			if lblText.modulate.a > 0:
				lblText.modulate.a -= delta
			else:
				lblText.modulate.a = 0
				if textFading:
					textFading = false
					text_faded_out()
		else:
			if exitSayingFadeOutTimer < exitSayingFadeOutDelay:
				exitSayingFadeOutTimer += delta
			else:
				if lblText.modulate.a > 0:
					lblText.modulate.a -= delta
				else:
					lblText.modulate.a = 0
					if textFading:
						textFading = false
						text_faded_out()
				
	match state:
		GSSState.APPEARED:
			if btnsAppearTimer < BTNS_APPEAR_DELAY:
				btnsAppearTimer += delta
			else:
				btnM.disabled = false
				btnF.disabled = false
				if btnF.modulate.a < 1:
					btnF.modulate.a += delta
				else:
					btnF.modulate.a = 1
				if btnM.modulate.a < 1:
					btnM.modulate.a += delta
				else:
					btnM.modulate.a = 1
			pass
		GSSState.SELECTED:
			if genderSelected == Player.Gender.HOMIE:
				if btnF.modulate.a > 0:
					btnF.modulate.a -= delta
				else:
					btnF.modulate.a = 0
				pass
			else:
				if btnM.modulate.a > 0:
					btnM.modulate.a -= delta
				else:
					btnM.modulate.a = 0
				pass
			pass
		GSSState.LEAVING:
			if btnF.modulate.a > 0:
				btnF.modulate.a -= delta
			else:
				btnF.modulate.a = 0
			if btnM.modulate.a > 0:
				btnM.modulate.a -= delta
			else:
				btnM.modulate.a = 0
			pass
	pass

func select_m():
	select_gender(Player.Gender.HOMIE)
func select_f():
	select_gender(Player.Gender.HOMETTE)

func text_faded_out():
	if state == GSSState.SELECTED:
		lblText.text = strExitSaying
		set_text_fade_state(FadeState.IN)
		state = GSSState.LEAVING
		pass
	elif state == GSSState.LEAVING:
		eAnim.play("fadeout")
		#set_text_fade_state(FadeState.OUT)
	pass

func anim_done():
	var animName = eAnim.animation.get_basename()
	if animName == "reveal":
		e_revealed()
	elif animName == "fadeout":
		selectionDone.emit()
		queue_free()
	pass

func e_revealed():
	state = GSSState.APPEARED
	eAnim.play("pulsate")
	lblText.text = "who are you?"
	set_text_fade_state(FadeState.IN)
	btnM.visible = true
	btnM.modulate.a = 0
	btnF.visible = true
	btnF.modulate.a = 0
	pass

func select_gender(gender: Player.Gender):
	btnM.disabled = true
	btnF.disabled = true
	state = GSSState.SELECTED
	Game.set_gender(gender)
	genderWasSelected = true
	genderSelected = gender
	set_text_fade_state(FadeState.OUT)
	textQueued = strExitSaying
	if gender == Player.Gender.HOMIE:
		pass
	else:
		pass
	pass

func set_text_fade_state(newState: FadeState):
	lblText.visible = true
	lblText.modulate.a = newState
	textFadeState = newState
	if newState == FadeState.OUT:
		textFading = true
	pass
