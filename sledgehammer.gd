extends SwingWeapon
class_name Sledgehammer

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	weaponName = "Sledgehammer"
	description = "A hammer. Used for sledging"
	weaponType = WeaponType.Swing
	DAMAGE = 4
	
	collider = $collider
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

func _physics_process(delta):
	super._physics_process(delta)
	pass
