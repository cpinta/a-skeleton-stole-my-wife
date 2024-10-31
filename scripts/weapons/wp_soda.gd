extends Weapon
class_name Soda

@export var area: Area2D
@export var hitbox: CollisionPolygon2D

@export var curShootTime: float = 0

@export var THIRTEEN: int = 13


# Called when the node enters the scene tree for the first time.
func _ready():
	weaponName = "13 Pack of Soda"
	description = "The only baker's dozen I care about."
	BASE_DAMAGE = 0
	BASE_KNOCKBACK = 200
	BASE_DURATION = 0.5
	BASE_AMMO_COUNT = THIRTEEN
	currentAmmoCount = BASE_AMMO_COUNT
	
	collider = $collider
	
	anim = $animation
	anim.play("ground")
	
	area = $"collider"
	area.connect("area_entered", hit_entity)
	hitbox = area.get_node("shape")
	hitbox.disabled = true
	
	IS_QUITTABLE = false
	
	EQUIP_ANGLE = 135
	EQUIP_OFFSET = -Vector2.ONE * 2
	
	
	super._ready()
	elementHeight.SHADOW_USES_PARENT_ORIGIN = true
	drop(5)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
func _physics_process(delta):
	if inUse:
		if curShootTime < duration:
			anim.play("shoot")
			curShootTime += delta
		else:
			anim.play("idle")
			end_use_weapon()
	else:
		if isEquipped:
			anim.play("idle")
	super._physics_process(delta)

func use_weapon():
	super.use_weapon()
	if inUse:
		apply_stats()
		anim.play("shoot")
		curShootTime = 0
		hitbox.disabled = false
	pass
	
func end_use_weapon():
	super.end_use_weapon()
	curShootTime = 0
	hitbox.disabled = true
	currentAmmoCount -= 1
	if currentAmmoCount < 1:
		if ownerEntity is Player:
			(ownerEntity as Player).drop_weapon(self)
			queue_free()
			pass
	
	pass

func shoot():
	
	pass

func hit_entity(body: Node2D):
	super.hit_entity(body)
	pass
	
func apply_attack(entity: Entity):
	super.apply_attack(entity)
	if entity.hurt(damage, knockback, Vector2.RIGHT.rotated(global_rotation - deg_to_rad(45 * global_scale.y))):
		attack_hit.emit(entity, entity.wasKilledLastFrame, damage)
	pass

func equip():
	super.equip()
	anim.play("idle")
	
func unequip():
	super.unequip()
	anim.play("back")
	pass
	
func drop(height: float):
	super.drop(height)
	pass

func apply_stats():
	super.apply_stats()
	BASE_AMMO_COUNT = THIRTEEN
