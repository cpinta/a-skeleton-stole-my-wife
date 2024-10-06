extends Weapon
class_name ProjecteWeapon

@export var shootPoint: Node2D
@export var projectile: Projectile

@export var IS_CONTINUOUS: bool = true	#if the weapon is automatic or not
@export var continuousTimer: float = 0
@export var IS_FIRST_SHOT: bool = true
@export var BASE_CLIP_SIZE: int = 10
@export var bulletsInClip: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	IS_QUITTABLE = true
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
				if(bulletsInClip > 0):
					shoot()
				else:
					end_use_weapon()
		else:
			if(bulletsInClip > 0):
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
	bulletsInClip -= 1
	var proj = projectile.new()
	proj.global_rotation = shootPoint.global_rotation
	pass

func hit_entity(body: Node2D):
	var parent = body.get_parent()
	print("hit:",parent.name)
	if parent != null:
		if parent is Entity:
			var entity = parent as Entity
			entity.hurt(BASE_DAMAGE, BASE_KNOCKBACK, Vector2.RIGHT.rotated(global_rotation))
	pass
