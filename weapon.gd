extends Element
class_name Weapon

enum WeaponType {Swing, Poke, Projectile}

@export var weaponName := "Weapon"
@export var description := "this is a weapon"
@export var weaponType : WeaponType
@export var BASE_DAMAGE := 1
@export var BASE_COOLDOWN: float = 3
@export var BASE_ATTACKSPEED: float = 3
@export var BASE_DURATION: float = 1
@export var BASE_SIZE: float = 1
@export var BASE_KNOCKBACK: float = 1

@export var inUse := false
@export var onCooldown := false
@export var curCooldownTime:float = 0

@export var collider: CollisionObject2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass
	

func _physics_process(delta):
	if onCooldown:
		if(curCooldownTime > 0):
			curCooldownTime -= delta
		else:
			onCooldown = false
	super._physics_process(delta)
	pass

func use_weapon():
	inUse = true
	pass

func stop_use_weapon():
	inUse = false
	onCooldown = true
	curCooldownTime = BASE_COOLDOWN
	pass

func equip():
	pass

func unequip():
	pass
