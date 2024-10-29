extends Control
class_name Intro_Cutscene

var gender: Player.Gender

var foreground: Sprite2D
var background: Sprite2D

var textbox: Sprite2D
var lblTextbox: Label

var fadein: Fadein

var intro1m: CompressedTexture2D
var intro1f: CompressedTexture2D
var intro1skele: CompressedTexture2D

var intro2lookm: CompressedTexture2D
var intro2lookf: CompressedTexture2D

var introWalking: AnimatedSprite2D
var introWalkingStepCountTotal: int = 4
var introWalkingStepCount: int = 0

var intro2m: CompressedTexture2D
var intro2f: CompressedTexture2D

var intro3m: CompressedTexture2D
var intro3f: CompressedTexture2D
var intro3: CompressedTexture2D

var intro4m: CompressedTexture2D
var intro4f: CompressedTexture2D

var introRevealAnim: AnimatedSprite2D
var introRevealAnimf: AnimatedSprite2D
var introRevealAnimm: AnimatedSprite2D

var revealCounter: int = 0

var frameTimings: Array[float] = [5, 1, 1, 2, 1]
var currentFrame: int = 0
var timer: float = 0

signal introDone

func _ready():
	foreground = $foreground
	background = $background
	fadein = $fadein
	
	textbox = $Textbox
	textbox.visible = false
	lblTextbox = $Textbox/Control2/Control/text
	
	intro1m = load("res://sprites/intro/intro 1 m.png")
	intro1f = load("res://sprites/intro/intro 1 f.png")
	intro1skele = load("res://sprites/intro/intro 1 skeleback.png")
	
	intro2m = load("res://sprites/intro/intro 2 m.png")
	intro2f = load("res://sprites/intro/intro 2 f.png")
	
	introWalking = $walkinganim
	introWalking.stop()
	introWalking.visible = false
	introWalking.connect("animation_finished", walking_anim_done)
	introWalkingStepCount = 0
	
	intro2m = load("res://sprites/intro/intro 2 m.png")
	intro2f = load("res://sprites/intro/intro 2 f.png")
	
	intro3 = load("res://sprites/intro/intro 3.png")
	intro3m = load("res://sprites/intro/intro 3 m.png")
	intro3f = load("res://sprites/intro/intro 3 f.png")
	
	intro4m = load("res://sprites/intro/intro 4 m.png")
	intro4f = load("res://sprites/intro/intro 4 f.png")
	
	introRevealAnim = $revealanim
	introRevealAnim.visible = false
	introRevealAnimf = $"revealanim/player f"
	introRevealAnimf.visible = false
	introRevealAnimm = $"revealanim/player m"
	introRevealAnimm.visible = false
	introRevealAnim.connect("animation_finished", reveal_anim_done)
	
	currentFrame = 0
	
	gender = Game.chosenGender
	
	play_intro()
	pass
	
func reveal_anim_done():
	var animName = introRevealAnim.animation.get_basename()
	revealCounter -= 1
	if animName == "reveal":
		if revealCounter > 0:
			intro_reveal_anim_set("reveal")
		else:
			textbox.visible = true
			lblTextbox.text = "HAHA! ITS NOT YOUR WIFE! IT IS I!\n\nA SKELETON!"
			intro_reveal_anim_set("talk reveal")
			revealCounter = 20
			pass
		pass
	elif animName == "talk reveal":
		if revealCounter > 0:
			intro_reveal_anim_set("talk reveal")
		else:
			intro_reveal_anim_set("point clothes fall")
			revealCounter = 0
			textbox.visible = false
			pass
		pass
	elif animName == "point clothes fall":
		intro_reveal_anim_set("point talk")
		revealCounter = 40
		textbox.visible = true
		lblTextbox.text = "MY MONSTER ARMY IS CARRYING HER TO THE CEMETERY AT THIS MOMENT!"
		pass
	elif animName == "point talk":
		if revealCounter > 0:
			intro_reveal_anim_set("point talk")
			if revealCounter < 20:
				lblTextbox.text = "AND I AM GOING TO MAKE HER MY SKELETON BRIDE! HAHA!"
				pass
		else:
			textbox.visible = false
			intro_reveal_anim_set("dash")
			revealCounter = 0
			pass
		pass
	elif animName == "dash":
		introDone.emit()
		queue_free()
		pass
		
func intro_reveal_anim_set(name: String):
	introRevealAnim.play(name)
	introRevealAnimf.play(name)
	introRevealAnimm.play(name)
	pass
	
func _process(delta):
	if timer > 0:
		timer -= delta
		#print(Time.get_datetime_dict_from_system(),"PROCESS")
	pass
	
func play_intro():
	fadein.setup(frameTimings[currentFrame]/2)
	foreground.setup(frameTimings[currentFrame])
	
	await set_frame_and_timer(intro1m, intro1f)
	foreground.queue_free()
	fadein.queue_free()
	introWalking.visible = true
	introWalking.play("walk")
	pass
	
func play_intro2():
	await set_frame_and_timer(intro2m, intro2f)
	await set_frame_and_timer(intro3m, intro3f)
	await set_frame_and_timer(intro3, intro3)
	await set_frame_and_timer(intro4m, intro4f)
	background.queue_free()
	
	introRevealAnim.visible = true
	introRevealAnim.play("reveal")
	if gender == Player.Gender.HOMIE:
		introRevealAnimm.visible = true
		introRevealAnimf.visible = false
		pass
	else:
		introRevealAnimf.visible = true
		introRevealAnimm.visible = false
		pass
	
	
func set_frame_and_timer(frameHomie: CompressedTexture2D, frameHomette: CompressedTexture2D):
	if gender == Player.Gender.HOMIE:
		set_frame(frameHomie)
	else:
		set_frame(frameHomette)
	print("erm",frameTimings[currentFrame])
	await get_tree().create_timer(frameTimings[currentFrame], true, false, true).timeout
	currentFrame += 1
	pass

func set_frame(frame: CompressedTexture2D, layer: Sprite2D = background):
	layer.texture = frame
	timer = frameTimings[currentFrame]
	pass

func walking_anim_done():
	var animName = introWalking.animation.get_basename()
	if animName == "walk":
		if introWalkingStepCount > introWalkingStepCountTotal:
			play_intro2()
			introWalking.queue_free()
		else:
			introWalking.play("walk")
			introWalkingStepCount += 1
