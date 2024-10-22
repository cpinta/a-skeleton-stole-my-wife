extends ProgressBar
class_name UI_HealthBar

enum HealthBarType {MINI=0, MAIN=1}

var BAR_CHANGE_AMOUNT: float = 10
var target: Entity
var target_value: float = 0
var firstFrameAfterHit: bool = false

var DONT_SHOW_UNTIL_FIRST_HIT: bool = false

var type: HealthBarType

var lbl: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_nodes_in_group("player")[0]
	type = HealthBarType.MAIN
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
			change_size(max_value)
		if value != target.health:
			if DONT_SHOW_UNTIL_FIRST_HIT and not visible:
				visible = true
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
	
	match type:
		HealthBarType.MINI:
			lbl.text = ""
			pass
		HealthBarType.MAIN:
			lbl.text = str(target_value)+"/"+str(max_value)
			pass
	pass

func setup(newTarget: Entity, type: HealthBarType):
	target = newTarget
	max_value = target.STARTING_HEALTH
	value = target.health
	self.type = type
	match type:
		HealthBarType.MINI:
			change_size(max_value)
			DONT_SHOW_UNTIL_FIRST_HIT = true
			pass
		HealthBarType.MAIN:
			size = Vector2(100, 12)
			DONT_SHOW_UNTIL_FIRST_HIT = false
			pass
	visible = not DONT_SHOW_UNTIL_FIRST_HIT
			
func change_size(newSize: int):
	match type:
		HealthBarType.MINI:
			size = Vector2(newSize, 2)
			position = Vector2(-size.x/2, 3)
	
