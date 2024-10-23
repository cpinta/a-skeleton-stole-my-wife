extends Weapon
class_name SwingWeapon

@export var area: Area2D
@export var hitbox: CollisionShape2D

@export var FRONT_FACING_ANGLE := 135 #DO NOT CHANGE IN INHERITERS

@export var INHAND_ANGLE = 0

@export var SWING_ARC_ANGLE = 90
@export var SWING_START_ANGLE: float
@export var SWING_END_ANGLE: float

@export var HITSTUN_AMOUNT: float = 0.1

@export var curSwingTime: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	SWING_START_ANGLE = FRONT_FACING_ANGLE - (SWING_ARC_ANGLE/2)
	SWING_END_ANGLE = FRONT_FACING_ANGLE + (SWING_ARC_ANGLE/2)
	rotation_degrees = STORE_ANGLE
	INHAND_ANGLE = SWING_START_ANGLE
	
	area = $"collider"
	area.connect("area_entered", hit_entity)
	hitbox = area.get_node("shape")
	weaponType = WeaponType.Swing
	
	hitbox.disabled = true
	
	onHitEffects.append(SE_Hitstun.new(null, HITSTUN_AMOUNT))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	super._physics_process(delta)
	if inUse:
		if curSwingTime < duration:
			curSwingTime += delta
			rotation_degrees = SWING_START_ANGLE + ((curSwingTime/duration) * (SWING_END_ANGLE - SWING_START_ANGLE))
		else:
			end_use_weapon()
	pass

func use_weapon():
	super.use_weapon()
	if inUse:
		swing()
	pass
	
func end_use_weapon():
	super.end_use_weapon()
	rotation_degrees = INHAND_ANGLE
	hitbox.disabled = true
	pass

func swing():
	apply_stats()
	hitbox.disabled = false
	rotation_degrees = SWING_START_ANGLE
	curSwingTime = 0
	pass

func hit_entity(body: Node2D):
	super.hit_entity(body)
	pass
	
func apply_attack(entity: Entity):
	super.apply_attack(entity)
	if entity.hurt(damage, knockback, Vector2.RIGHT.rotated(global_rotation - deg_to_rad(45 * global_scale.y)), true, onHitEffects):
		attack_hit.emit(entity, entity.wasKilledLastFrame, damage)
	pass
	
func unequip():
	super.unequip()
	hitbox.disabled = true
	pass
