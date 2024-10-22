extends ProgressBar
class_name UI_HealthBar

var BAR_CHANGE_AMOUNT: float = 10
var target: Entity
var target_value: float = 0
var firstFrameAfterHit: bool = false

var lbl: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_nodes_in_group("player")[0]
	max_value = target.health
	value = target.health
	target_value = value
	
	lbl = $num
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		target_value = target.health
		if max_value != target.STARTING_HEALTH:
			var diff: float = sign(target.health - value) * BAR_CHANGE_AMOUNT * delta
			max_value += diff
		if value != target.health:
			if not firstFrameAfterHit:
				var diff: float = sign(target.health - value) * BAR_CHANGE_AMOUNT * delta
				value += diff
				if sign(target.health - value) != sign(diff):
					value = target.health
			else:
				firstFrameAfterHit = false
		else:
			firstFrameAfterHit = true
	else:
		target_value = 0
		if value > 0:
			var diff: float = -1 * BAR_CHANGE_AMOUNT * delta
			value += diff
			
	lbl.text = str(target_value)+"/"+str(max_value)
	pass

func setup(maxHealth: int):
	self.maxHealth = maxHealth
