extends SwingWeapon
class_name Sledgehammer

# Called when the node enters the scene tree for the first time.
func _ready():
	weaponName = "Sledgehammer"
	description = "A hammer. Used for sledging"
	BASE_DAMAGE = 4
	BASE_KNOCKBACK = 150
	SWING_ARC_ANGLE = 180
	BASE_DURATION = 1
	
	HITSTUN_AMOUNT = 0.2
	START_DROPPED = false
	
	EQUIP_ANGLE = 45
	STORE_ANGLE = -90
	
	collider = $collider
	anim = get_node("animation")
	
	super._ready()
	elementHeight.SHADOW_USES_PARENT_ORIGIN = true
	drop(5)
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
