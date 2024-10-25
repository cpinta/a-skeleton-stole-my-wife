extends Node2D
class_name EntityCombo

var comboCount: int = 0
var COMBO_SCORE_MULTIPLIER_ADDITION: float = 0.05

var COMBO_TIME: float = 2.5
var comboTimer: float = 0
signal combo_point_added

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if comboTimer > 0:
		comboTimer -= delta
	else:
		comboCount = 0
	pass

func add():
	comboCount += 1
	comboTimer = COMBO_TIME
	combo_point_added.emit()
	
func drop():
	comboCount = 0
	comboTimer = 0
	
func apply_multiplier(value: float):
	return value * (1 + COMBO_SCORE_MULTIPLIER_ADDITION * comboCount)
