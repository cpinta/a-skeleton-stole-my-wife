extends ProgressBar
class_name UI_HealthBar

var BAR_CHANGE_AMOUNT: float = 10
var target: Entity
var actual_value: float = 0
var firstFrameAfterHit: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_nodes_in_group("player")[0]
	max_value = target.health
	value = target.health
	actual_value = value
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		if max_value != target.STARTING_HEALTH:
			var diff: float = sign(target.health - value) * BAR_CHANGE_AMOUNT * delta
			max_value += diff
		if value != target.health:
			if not firstFrameAfterHit:
				var diff: float = sign(target.health - value) * BAR_CHANGE_AMOUNT * delta
				actual_value += diff
				if sign(target.health - actual_value) != sign(diff):
					actual_value = target.health
			else:
				firstFrameAfterHit = false
		else:
			firstFrameAfterHit = true
	else:
		if value > 0:
			var diff: float = -1 * BAR_CHANGE_AMOUNT * delta
			actual_value += diff
	
	value = actual_value
	pass

func setup(maxHealth: int):
	self.maxHealth = maxHealth
