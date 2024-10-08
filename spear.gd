extends PokeWeapon
class_name Spear


# Called when the node enters the scene tree for the first time.
func _ready():
	weaponName = "Spear"
	description = "Poke! Poke! Poke!"
	weaponType = WeaponType.Poke
	BASE_DAMAGE = 0
	BASE_KNOCKBACK = 150
	BASE_DURATION = 0.5
	
	EQUIP_ANGLE = 90
	STORE_ANGLE = -45
	
	collider = $collider
	
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
