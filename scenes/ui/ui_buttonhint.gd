extends Node2D
class_name UI_ButtonHint

var char: Sprite2D
var key: AnimatedSprite2D

var unpressedPos: int = -2
var pressedPos: int = -1

@export var actionName: String


# Called when the node enters the scene tree for the first time.
func _ready():
	char = $char
	key = $key
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = 0
	if actionName != null and actionName != "":
		if InputMap.has_action(actionName):
			if Input.is_action_pressed(actionName):
				pressed()
			else:
				unpressed()
	pass
	
func setup(newActionName: String):
	actionName = newActionName
	for event in InputMap.action_get_events(actionName):
		print(event.as_text())
		var keyName: String = event.as_text().split(" (")[0]
		var path: String = "res://sprites/ui/chars/char_"+keyName+".png"
		if FileAccess.file_exists(path):
			char.texture = load(path)
			return
	print("couldnt find graphic for graphicHint. Action: "+actionName)
	var path: String = "res://sprites/ui/chars/char_.png"
	if FileAccess.file_exists(path):
		char.texture = load(path)

func pressed():
	key.play("pressed")
	char.position.y = pressedPos
	
func unpressed():
	key.play("unpressed")
	char.position.y = unpressedPos
	
