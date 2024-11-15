extends SwingWeapon
class_name Scythe

@export var SLOW_TIME: float = 2
@export var SLOW_MULTIPLIER: float = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	weaponName = "Scythe"
	description = "It'll look grim for them!"
	BASE_DAMAGE = 4
	BASE_KNOCKBACK = 0
	SWING_ARC_ANGLE = 180
	BASE_DURATION = 1
	
	EQUIP_ANGLE = 45
	STORE_ANGLE = 0
	
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

func apply_attack(entity: Entity):
	super.apply_attack(entity)
	entity.add_status_effect(SE_MovementSlow.new(entity, SLOW_TIME, SLOW_MULTIPLIER))
	pass

func _on_collider_area_entered(area):
	pass # Replace with function body.
