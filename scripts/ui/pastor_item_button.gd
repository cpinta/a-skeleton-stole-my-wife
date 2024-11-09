extends Button
class_name PastorItemButton

var LERP_SPEED: float = 20

var innerControl: Control
var baseScale: Vector2 = Vector2.ONE * 0.5
var hoverScale: Vector2 = Vector2.ONE

var itemAnim: AnimatedSprite2D
var strSmall: String = "small"
var strLarge: String = "large"

@export var description: String = ""

var touchButton: TouchScreenButton

signal wasSelected(item: String)

func _ready():
	innerControl = $Control
	innerControl.scale = baseScale
	itemAnim = innerControl.get_node("sprite")
	itemAnim.play(strSmall)
	pressed.connect(was_pressed)
	
	touchButton = $Control/touchbutton
	touchButton.released.connect(was_pressed)
	pass

func _process(delta):
	if is_hovered():
		innerControl.scale = lerp(innerControl.scale, hoverScale, delta * LERP_SPEED)
		pass
	else:
		innerControl.scale = lerp(innerControl.scale, baseScale, delta * LERP_SPEED)
		pass
		
	if innerControl.scale.x > ((hoverScale - baseScale)/2).x:
		itemAnim.play(strLarge)
		pass
	else:
		itemAnim.play(strSmall)
	pass

func was_pressed():
	wasSelected.emit(self.name)
	pass
