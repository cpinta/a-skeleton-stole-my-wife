extends Control
class_name UI_ScoreCounter

@onready var target: Entity = Game.player

var lblScore: Label

func _ready():
	lblScore = get_node("Label")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		lblScore.text = "monster essence\n"
		lblScore.text += str(Game.player.score)
	else:
		target = Game.player
	pass
