extends Node2D
class_name Skeleton

var anim: AnimatedSprite2D

var enterBox: Area2D
var enteredAlready: bool = false
@export var doorblocker: CollisionShape2D
@export var doorblockerSprite: Sprite2D

var strEnterTalk1: String = "Oh hi! Y'know, I was just talking about you!"
var strEnterTalk2: String = "You almost have enough essence to do damage!"
var strEnterTalk3: String = "Like that'll ever happen! HEEHEE!"

var strSnarkTalk1: String = "OOFIE! That tickles!"
var strSnarkTalk2: String = "Okay, let me invite my friend... SATAN! HEEHEE"
var strSnarkTalk3: String = "Alright buddy, cut it out! This isnt funny!"

var FIRST_SNARK_SCORE: int = 700
var SECOND_SNARK_SCORE: int = 900
var THIRD_SNARK_SCORE: int = 1100

var snarkLevel: int = 0
var snarking: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	anim = $animation
	anim.play("staring straight")
	
	enterBox = $introTalkArea
	enterBox.area_entered.connect(entered)
	doorblocker.disabled = true
	doorblockerSprite.visible = false
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match snarkLevel:
		1:
			if Game.player.score > FIRST_SNARK_SCORE:
				if not snarking:
					first_snark_text()
				pass
		2:
			if Game.player.score > SECOND_SNARK_SCORE:
				if not snarking:
					second_snark_text()
				pass
		3:
			if Game.player.score > THIRD_SNARK_SCORE:
				if not snarking:
					third_snark_text()
				pass
			
	
	pass

func first_entered():
	if Game.gameUI != null:
		doorblocker.set_deferred("disabled", false)
		doorblockerSprite.visible = true
		anim.play("pbj time")
		intro_text()
	pass
	
func intro_text():
	await speak_for_time(strEnterTalk1, 5)
	await speak_for_time(strEnterTalk2, 5)
	await speak_for_time(strEnterTalk3, 5, 1)
	snarkLevel += 1
	
func first_snark_text():
	snarking = true
	await speak_for_time(strSnarkTalk1, 5)
	snarkLevel += 1
	snarking = false

func second_snark_text():
	anim.play("on knees")
	snarking = true
	await speak_for_time(strSnarkTalk2, 5)
	snarkLevel += 1
	snarking = false
	
func third_snark_text():
	anim.play("talk on knees hands up")
	snarking = true
	await speak_for_time(strSnarkTalk3, 5)
	snarkLevel += 1
	snarking = false
	pass

func speak_for_time(text: String, time:float, shake:float = 0):
	Game.gameUI.centerText.set_center_text(text, time, shake)
	await get_tree().create_timer(time, true, false, true).timeout
	pass

func entered(body: Node2D):
	if enteredAlready:
		return
	var parent = body.get_parent().get_parent()
	print("hit:",parent.name)
	if parent != null:
		if parent is Player:
			enteredAlready = true
			first_entered()
	pass
