extends TextureProgressBar
class_name UI_Cooldown

var playerWeaponIndex: int

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target = Game.player.weapons[playerWeaponIndex]
	if target != null:
		if target.onCooldown:
			visible = true
			max_value = target.cooldown
			value = target.cooldownTimer
		else:
			visible = false
		pass

func setup(newIndex: int):
	playerWeaponIndex = newIndex
