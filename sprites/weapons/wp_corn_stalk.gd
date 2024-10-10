extends PokeWeapon
class_name CornStalk

# Called when the node enters the scene tree for the first time.
func _ready():
	weaponName = "Sceptre"
	description = "Poke! Poke! Poke!"
	BASE_DAMAGE = 0
	BASE_KNOCKBACK = 150
	BASE_DURATION = 0.5
	BASE_COOLDOWN = 0.25
	
	EQUIP_ANGLE = 135
	STORE_ANGLE = -90
	
	anim = $animation
	collider = $collider
	
	super._ready()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stabbing:
		anim.play("stab")
	else:
		anim.play("idle")
	pass
