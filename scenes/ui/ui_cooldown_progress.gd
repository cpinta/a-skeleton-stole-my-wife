extends TextureProgressBar
class_name UI_Cooldown

var target: Weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		if target.onCooldown:
			visible = true
			max_value = target.cooldown
			value = target.cooldownTimer
		else:
			visible = false
		pass

func setup(newTarget: Weapon):
	target = newTarget
