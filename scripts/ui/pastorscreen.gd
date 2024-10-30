extends Control
class_name PastorScreen

enum PastorState {INTRO, SHOWING_ITEMS, LEAVING}

var state: PastorState

var buttonParent: Control
var BUTTONS_START_Y: float = 98
var revealButtons: bool = false

var buttons: Array[PastorItemButton]

var animPastor: AnimatedSprite2D
var PASTOR_START_X: float = -130
var PASTOR_SLIDEIN_SPEED: float = 120

var TALK_TIME: float = 1.25
var talkTimer: float = 0

var lblTextBox: Label
var lastHovered: PastorItemButton 

var strIntro1: String = "Seems that skeleton is bombarding the town with demons!"
var strIntro2: String = "Gain enough monster essence and you'll save us and your wife!"
var strIntro3: String = "Here, take this hammer and fight those monsters!"

var strItemTut: String = "Those monsters seem tough. One of these could help you."
var strItemNoTut: String = "Here take one of these."

var started: bool = false

var isTutorialFinished: bool = false

func _ready():
	animPastor = $pastor
	animPastor.position.x = PASTOR_START_X
	
	buttonParent = $Buttons
	buttonParent.position.y = BUTTONS_START_Y
	
	for button in buttonParent.get_children():
		buttons.append(button)
		button.wasSelected.connect(item_selected)
		button.disabled = true
	
	lblTextBox = $textbox/Control/text
	lblTextBox.text = ""
	
	setup(PastorState.SHOWING_ITEMS, true)
	disable_buttons()
	pass
	
func setup(state: PastorState = PastorState.SHOWING_ITEMS, hasTutorial: bool = false):
	self.state = state
	isTutorialFinished = not hasTutorial

func disable_buttons():
	for button in buttons:
		button.disabled = true

func enable_buttons():
	for button in buttons:
		button.disabled = false

func item_selected(itemName:String):
	var buttonSelected: PastorItemButton
	match itemName:
		"Weight":
			if Game.player != null:
				Game.player.add_status_effect(SE_Attack_Damage.new(Game.player, 99999999999, 3))
			pass
		"Glove":
			if Game.player != null:
				Game.player.add_status_effect(SE_Attack_Speed.new(Game.player, 99999999999, 1))
			pass
		"Boots":
			if Game.player != null:
				Game.player.add_status_effect(SE_Movement_Speed.new(Game.player, 99999999999, 20))
			pass
		"Corndog":
			if Game.player != null:
				Game.player.add_status_effect(SE_Health.new(Game.player, 99999999999, 5))
			pass
	
	disable_buttons()
	pass

func _process(delta):
	match state:
		PastorState.INTRO:
			if animPastor.position.x < 0:
				animPastor.position.x += PASTOR_SLIDEIN_SPEED * delta
			else:
				animPastor.position.x = 0
				if not started:
					started = true
					intro_speak()
			pass
		PastorState.SHOWING_ITEMS:
			if animPastor.position.x < 0:
				animPastor.position.x += PASTOR_SLIDEIN_SPEED * delta
			else:
				animPastor.position.x = 0
				if not started:
					started = true
					item_speak()
			
			if isTutorialFinished:
				if buttonParent.position.y > 0:
					buttonParent.position.y -= PASTOR_SLIDEIN_SPEED * delta
				else:
					buttonParent.position.y = 0
					if buttons[0].disabled:
						enable_buttons()
			
			for button in buttons:
				if button.is_hovered():
					if button != lastHovered:
						lastHovered = button
						speak(button.description)
					pass
			pass
		PastorState.LEAVING:
			if buttonParent.position.y < BUTTONS_START_Y:
				buttonParent.position.y += PASTOR_SLIDEIN_SPEED * delta
			else:
				buttonParent.position.y = BUTTONS_START_Y
			pass
		
			if animPastor.position.x > PASTOR_START_X:
				animPastor.position.x -= PASTOR_SLIDEIN_SPEED * delta
			else:
				queue_free()
	
		
	if talkTimer > 0:
		talkTimer -= delta
		animPastor.play("talk")
	else:
		animPastor.play("idle")
	pass
	
func item_speak():
	if isTutorialFinished:
		await speak_for_time(strItemNoTut, 5)
	else:
		await speak_for_time(strItemTut, 5)
		isTutorialFinished = true
	pass

func intro_speak():
	await speak_for_time(strIntro1, 5)
	await speak_for_time(strIntro2, 5)
	await speak_for_time(strIntro3, 5)
	state = PastorState.LEAVING
	pass

func speak_for_time(text: String, time:float):
	speak(text, time - 2)
	await get_tree().create_timer(time, true, false, true).timeout
	pass

func speak(text: String, textTime: float = TALK_TIME):
	talkTimer = TALK_TIME
	lblTextBox.text = text
	pass
