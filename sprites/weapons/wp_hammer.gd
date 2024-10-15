extends SwingWeapon
class_name Hammer


# Called when the node enters the scene tree for the first time.
func _ready():
	weaponName = "Hammer"
	description = "To repair. Or destroy??"
	BASE_DAMAGE = 0
	BASE_KNOCKBACK = 75
	SWING_ARC_ANGLE = 135
	BASE_DURATION = 0.35
	
	EQUIP_ANGLE = 45
	STORE_ANGLE = 0
	
	collider = $collider
	anim = get_node("animation")
	
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
