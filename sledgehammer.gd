extends SwingWeapon
class_name Sledgehammer

# Called when the node enters the scene tree for the first time.
func _ready():
	weaponName = "Sledgehammer"
	description = "A hammer. Used for sledging"
	weaponType = WeaponType.Swing
	BASE_DAMAGE = 0
	BASE_KNOCKBACK = 150
	SWING_ARC_ANGLE = 180
	BASE_DURATION = 0.5
	
	collider = $collider
	
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

func _physics_process(delta):
	super._physics_process(delta)
	pass


func _on_collider_area_entered(area):
	pass # Replace with function body.
