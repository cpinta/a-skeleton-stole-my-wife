extends PokeWeapon
class_name CornStalk

# Called when the node enters the scene tree for the first time.
func _ready():
	weaponName = "Corn Stalk"
	description = "Stalk up or stalk out."
	BASE_DAMAGE = 1
	BASE_KNOCKBACK = 100
	BASE_DURATION = 0.25
	BASE_COOLDOWN = 0.1
	
	EQUIP_ANGLE = 135
	STORE_ANGLE = -90
	
	anim = $animation
	collider = $collider
	anim = get_node("animation")
	
	super._ready()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if stabbing:
		anim.play("stab")
	else:
		anim.play("idle")
	pass
