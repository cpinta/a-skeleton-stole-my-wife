extends CanvasLayer
class_name UI

var centerText: UI_CenterText

# Called when the node enters the scene tree for the first time.
func _ready():
	centerText = $"Control/MarginContainer/Control/center text"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
