extends Weapon
class_name ProjecteWeapon

@export var shootPoint: Node2D
@export var projectile: PackedScene

@export var IS_CONTINUOUS: bool = true	#if the weapon is automatic or not
@export var continuousTimer: float = 0
@export var IS_FIRST_SHOT: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	BASE_AMMO_COUNT = 10
	super._ready()
	IS_QUITTABLE = true
	currentAmmoCount = BASE_AMMO_COUNT
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	super._physics_process(delta)
	if inUse:
		if IS_CONTINUOUS:
			if(continuousTimer > 0):
				continuousTimer -= delta
			else:
				if(currentAmmoCount > 0):
					shoot()
				else:
					end_use_weapon()
		else:
			if(currentAmmoCount > 0):
				shoot()
				quit_use_weapon()
			else:
				end_use_weapon()
				pass
			pass
	pass

func use_weapon():
	super.use_weapon()
	pass
	
func end_use_weapon():
	super.end_use_weapon()
	pass
	
func quit_use_weapon():
	super.quit_use_weapon()
	pass

func shoot():
	apply_stats()
	currentAmmoCount -= 1
	var proj: Projectile = projectile.instantiate()
	Game.add_child(proj)
	proj.global_position = shootPoint.global_position
	proj.global_rotation = shootPoint.global_rotation
	proj.setup(ownerEntity, attackspeed, damage)
	pass
	
func cooldown_over():
	super.cooldown_over()
	reload()
	pass
	
func reload():
	currentAmmoCount = ammoCount
	pass

func hit_entity(body: Node2D):
	super.hit_entity(body)
	pass
