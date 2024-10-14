extends SwingWeapon
class_name Scythe

@export var SLOW_TIME: float = 0.5
@export var SLOW_MULTIPLIER: float = 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	weaponName = "Scythe"
	description = "It'll look grim for them"
	BASE_DAMAGE = 0
	BASE_KNOCKBACK = 0
	SWING_ARC_ANGLE = 180
	BASE_DURATION = 0.25
	
	EQUIP_ANGLE = 45
	STORE_ANGLE = -45
	
	collider = $collider
	anim = get_node("animation")
	animGroundHeight = anim.position.y
	
	super._ready()
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
