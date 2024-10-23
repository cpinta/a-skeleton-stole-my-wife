extends Item
class_name Weapon

enum WeaponType {Swing, Poke, Projectile}

@export var weaponName := "Weapon"
@export var description := "this is a weapon"
@export var weaponType : WeaponType
@export var BASE_DAMAGE := 1
@export var BASE_COOLDOWN: float = 1
@export var BASE_ATTACKSPEED: float = 3
@export var BASE_DURATION: float = 1
@export var BASE_SIZE: float = 1
@export var BASE_KNOCKBACK: float = 1
@export var BASE_RANGE: float = 1
@export var BASE_AMMO_COUNT: int = 1

@export var IS_QUITTABLE: bool = false

@export var EQUIP_ANGLE: int = 0
@export var EQUIP_OFFSET: Vector2 = Vector2.ZERO

@export var damage := 1
@export var cooldown: float = 3
@export var attackspeed: float = 3
@export var duration: float = 1
@export var size: float = 1
@export var knockback: float = 1
@export var range: float = 1
@export var ammoCount: int = 1
@export var currentAmmoCount: int = 1

@export var cooldownTimer: float = 0

var onHitEffects: Array[StatusEffect]

@export var inUse := false
@export var onCooldown := false
@export var isEquipped := false

signal attack_hit(entity: Entity, entityWasKilled: bool, damageDealt: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass
	

func _physics_process(delta):
	if onCooldown:
		if(cooldownTimer > 0):
			cooldownTimer -= delta
		else:
			cooldown_over()
	super._physics_process(delta)
	pass

func use_weapon():
	if not onCooldown or inUse:
		inUse = true
	pass

func cooldown_over():
	onCooldown = false
	pass

func end_use_weapon():
	inUse = false
	onCooldown = true
	cooldownTimer = BASE_COOLDOWN
	pass
	
func quit_use_weapon():
	if IS_QUITTABLE:
		inUse = false
	pass

#called when weapon is put in players hand
func equip():
	rotation_degrees = EQUIP_ANGLE
	position = EQUIP_OFFSET
	isEquipped = true
	pass

#called when weapon is put on players back
func unequip():
	rotation_degrees = STORE_ANGLE
	position = Vector2.ZERO
	isEquipped = false
	pass
	
func hit_entity(body: Node2D):
	var parent = body.get_parent().get_parent()
	print("hit:",parent.name)
	if parent != null:
		if parent is Entity:
			var entity = parent as Entity
			apply_attack(entity)
	pass
	
func apply_attack(entity: Entity):
	apply_stats()
	update_effects(entity)
	pass
	
func update_effects(entity: Entity):
	for effect in onHitEffects:
		effect.target = entity
	
func apply_stats():
	damage = BASE_DAMAGE
	cooldown = BASE_COOLDOWN
	attackspeed = BASE_ATTACKSPEED
	duration = BASE_DURATION
	size = BASE_SIZE
	knockback = BASE_KNOCKBACK
	range = BASE_RANGE
	ammoCount = BASE_AMMO_COUNT
	
	if ownerEntity != null:
		damage *= ownerEntity.attack_damage
		cooldown *= ownerEntity.attack_cooldown
		attackspeed *= ownerEntity.attack_speed
		duration *= ownerEntity.attack_duration
		size *= ownerEntity.attack_size
		knockback *= ownerEntity.attack_knockback
		range *= ownerEntity.attack_range
	pass
	
func pickup(entity : Entity):
	super.pickup(entity)
	equip()
	pass
	
func drop(height: float):
	super.drop(height)
	pass
