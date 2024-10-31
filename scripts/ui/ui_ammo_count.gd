extends Label
class_name UI_Ammo_Count

var playerWeaponIndex: int

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.player != null:
		var target = Game.player.weapons[playerWeaponIndex]
		if target != null:
			if target.usesAmmo:
				visible = true
				text = str(target.currentAmmoCount)+"/"+str(target.ammoCount)
			else:
				visible = false
			pass

func setup(newIndex: int):
	playerWeaponIndex = newIndex
