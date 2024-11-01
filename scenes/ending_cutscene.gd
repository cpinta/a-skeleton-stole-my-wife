extends Control
class_name EndingCutscene

enum EndCSstate {BEGINNING, CLOSEUP, ENDING}

var state: EndCSstate
var stateIndex: int = 0

var ending1Anim: AnimatedSprite2D
var closeAnim: AnimatedSprite2D
var ending3Animm: AnimatedSprite2D
var ending3Animf: AnimatedSprite2D

var END1_YELLING_TIME: float = 4
var END1_STANDING_TIME: float = 1
var END1_TALKING_TIME1: float = 5
var END1_TALKING_TIME2: float = 4

var END2_IDLE_TIME: float = 0.5
var END2_TALKING_TIME1: float = 5
var END2_TALKING_TIME2: float = 5

var END2_CLOSE_TALKING_TIME: float = 5
var END2_REAL_CLOSE_TIME: float = 4

var END2_CLOSE_LABEL_Y: float = 130
var END2_CLOSE_CLOSE_LABEL_Y: float = 150
var END2_REAL_CLOSE_LABEL_Y: float = 157

var END3_TALK_TIME: float = 4
var END3_TALK_WAVE_TIME: float = 4

var timer: float = 0


var lblNOOO: Label
var lblEnd1: Label
var lblEnd2: Label
var lblEnd3: Label

var strEnd1a1: String = "NNOOOOOOO"
var strEnd1a2: String = "Did you really think you could kill me?"
var strEnd1a3: String = "A hammer against my being?"

var strEnd2a1: String = "I am no skin n bones."
var strEnd2a2: String = "I do not decompose."

var strEnd2a3: String = "I do not live by the feable constraints of life and death."
var strEnd2a4: String = "I am and always will be."

var strEnd3a1: String = "ANYWHO Im off to skin your wife!"
var strEnd3a2: String = "Hopefully you catch up! teehee!"

signal endingDone

# Called when the node enters the scene tree for the first time.
func _ready():
	
	ending1Anim = $"1/ending1Anim"
	ending1Anim.visible = true
	ending1Anim.animation_finished.connect(ending_one_anim_done)
	ending1Anim.play("1 yelling")
		
	closeAnim = $"2/closeAnim"
	closeAnim.visible = false
	
	ending3Animm = $"3/ending3Animm"
	ending3Animm.animation_finished.connect(ending_three_anim_done)
	ending3Animm.visible = false
	
	ending3Animf = $"3/ending3Animf"
	ending3Animf.animation_finished.connect(ending_three_anim_done)
	ending3Animf.visible = false
	
	lblNOOO = $"1/NOOOO"
	lblNOOO.visible = true
	
	lblEnd1 = $"1/text"
	lblEnd2 = $"2/text"
	lblEnd3 = $"3/text"
	
	
	change_state(EndCSstate.BEGINNING)
	
	pass # Replace with function body.

func change_state(newState: EndCSstate):
	state = newState
	stateIndex = 0
	match state:
		EndCSstate.BEGINNING:
			ending1Anim.visible = true
			lblNOOO.visible = true
			ending1Anim.play("1 yelling")
			timer = END1_YELLING_TIME
			
			lblEnd1.visible = true
			lblEnd2.visible = false
			lblEnd3.visible = false
			pass
		EndCSstate.CLOSEUP:
			ending1Anim.visible = false
			closeAnim.visible = true
			closeAnim.play("idle")
			timer = END2_IDLE_TIME
			
			lblEnd1.visible = false
			lblEnd2.visible = true
			lblEnd2.position.y = END2_CLOSE_LABEL_Y
			lblEnd3.visible = false
			pass
		EndCSstate.ENDING:
			closeAnim.visible = false
			if Game.chosenGender == Player.Gender.HOMIE:
				ending3Animm.visible = true
				ending3Animm.play("1 start")
			else:
				ending3Animf.visible = true
				ending3Animf.play("1 start")
				
			
			lblEnd1.visible = false
			lblEnd2.visible = false
			lblEnd3.visible = true
			pass
	pass

func ending_one_anim_done():
	var animName: String = ending1Anim.animation.get_basename()
	if animName == "standing fade":
		ending1Anim.play("standing")
		timer = END1_STANDING_TIME
		stateIndex += 1
		pass
	pass

func ending_three_anim_done():
	var animName: String = ""
	if Game.chosenGender == Player.Gender.HOMIE:
		animName = ending3Animm.animation.get_basename()
	else:
		animName = ending3Animf.animation.get_basename()
		
	if animName == "1 start":
		if Game.chosenGender == Player.Gender.HOMIE:
			ending3Animm.play("1 talk")
		else:
			ending3Animf.play("1 talk")
		
		
		timer = END3_TALK_TIME
		lblEnd3.text = strEnd3a1
		stateIndex += 1
		pass
	elif animName == "dash":
		if Game.chosenGender == Player.Gender.HOMIE:
			ending3Animm.play("player")
		else:
			ending3Animf.play("player")
		pass
		stateIndex += 1
	elif animName == "player":
		endingDone.emit()
		queue_free()
		pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		EndCSstate.BEGINNING:
			match stateIndex:
				0:	#1 yelling
					if timer > 0:
						timer -= delta
						pass
					else:
						ending1Anim.play("standing fade")
						lblNOOO.visible = false
						stateIndex += 1
						pass
					pass
				1:	#standing fade
					pass
				2:	#standing
					if timer > 0:
						timer -= delta
						pass
					else:
						ending1Anim.play("standing talk")
						timer = END1_TALKING_TIME1
						lblEnd1.text = strEnd1a2
						stateIndex += 1
						pass
					pass
				3:	#standing talk 1
					if timer > 0:
						timer -= delta
						pass
					else:
						timer = END1_TALKING_TIME2
						lblEnd1.text = strEnd1a3
						stateIndex += 1
						pass
					pass
				4:	#standing talk 2
					if timer > 0:
						timer -= delta
						pass
					else:
						change_state(EndCSstate.CLOSEUP)
						pass
					pass
			pass
		EndCSstate.CLOSEUP:
			match stateIndex:
				0:	#idle time
					if timer > 0:
						timer -= delta
						pass
					else:
						closeAnim.play("talking")
						timer = END2_TALKING_TIME1
						lblEnd2.text = strEnd2a1
						stateIndex += 1
						pass
					pass
				1:	#talk time 1
					if timer > 0:
						timer -= delta
						pass
					else:
						timer = END2_TALKING_TIME2
						lblEnd2.text = strEnd2a2
						stateIndex += 1
						pass
					pass
				2:	#talk time 2
					if timer > 0:
						timer -= delta
						pass
					else:
						closeAnim.play("close up")
						lblEnd2.position.y = END2_CLOSE_CLOSE_LABEL_Y
						timer = END2_CLOSE_TALKING_TIME
						lblEnd2.text = strEnd2a3
						stateIndex += 1
						pass
					pass
				3:	#close up time
					if timer > 0:
						timer -= delta
						pass
					else:
						closeAnim.play("real close")
						lblEnd2.position.y = END2_REAL_CLOSE_LABEL_Y
						timer = END2_REAL_CLOSE_TIME
						lblEnd2.text = strEnd2a4
						stateIndex += 1
						pass
					pass
				4:	#real close up time
					if timer > 0:
						timer -= delta
						pass
					else:
						change_state(EndCSstate.ENDING)
						pass
					pass
			pass
		EndCSstate.ENDING:
			match stateIndex:
				1:	#1 talk
					if timer > 0:
						timer -= delta
						pass
					else:
						if Game.chosenGender == Player.Gender.HOMIE:
							ending3Animm.play("talk wave")
						else:
							ending3Animf.play("talk wave")
						timer = END3_TALK_WAVE_TIME
						lblEnd3.text = strEnd3a2
						stateIndex += 1
						pass
					pass
				2:	#talk wave
					if timer > 0:
						timer -= delta
						pass
					else:
						if Game.chosenGender == Player.Gender.HOMIE:
							ending3Animm.play("dash")
						else:
							ending3Animf.play("dash")
						lblEnd3.visible = false
						stateIndex += 1
						pass
					pass
			pass
	pass
