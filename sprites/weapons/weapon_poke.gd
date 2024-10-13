extends Weapon
class_name PokeWeapon

@export var area: Area2D
@export var hitbox: CollisionShape2D

@export var BASE_POKE_LENGTH: float = 20
@export var BASE_PULLBACK_LENGTH: float = 20
@export var BASE_PULLBACK_TIME: float = 3
@export var BASE_POKE_TIME: float = 3

@export var poke_length: float = 40
@export var pullback_length: float = 20
@export var pullback_time: float = 0.25
@export var poke_time: float = 0.25

@export var NEUTRAL_POSITION: float = 0

@export var pullingBack: bool = false
@export var pulledBack: bool = false
@export var stabbing: bool = false
@export var pokeTimer: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	area = $"collider"
	area.connect("area_entered", hit_entity)
	hitbox = area.get_node("shape")
	weaponType = WeaponType.Poke
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	super._physics_process(delta)
	if inUse:
		if pullingBack || pulledBack:
			if not pulledBack:
				if pokeTimer < pullback_time:
					position.y = NEUTRAL_POSITION + ((pokeTimer/pullback_time) * (NEUTRAL_POSITION - pullback_length)) 
					pokeTimer += delta
				else:
					pulled_back()
			else:
				position.y = -pullback_length
		else:
			if stabbing:
				if pokeTimer < poke_time:
					position.y = (NEUTRAL_POSITION - pullback_length) + ((pokeTimer/poke_time) * (poke_length + pullback_length)) 
					pokeTimer += delta
				else:
					stab_over()
	else:
		if position.y > NEUTRAL_POSITION:
			if pokeTimer < poke_time:
				position.y = (NEUTRAL_POSITION + poke_length) + ((pokeTimer/poke_time) * (-poke_length)) 
				pokeTimer += delta
			else:
				position.y = NEUTRAL_POSITION
		position = position.lerp(Vector2(0, NEUTRAL_POSITION), 0.99 * delta)
		pass
	pass

func use_weapon():
	var willPullback: bool = false
	if not inUse:
		willPullback = true
		stabbing = false
		pullingBack = false
		pulledBack = false
	super.use_weapon()
	if willPullback:
		pull_back()
	pass
	
func pull_back():
	apply_stats()
	hitbox.disabled = true
	pullingBack = true
	pokeTimer = 0
	pass
	
func pulled_back():
	pullingBack = false
	pulledBack = true
	pokeTimer = 0
	pass
	
func start_stab():
	pullingBack = false
	pulledBack = false
	stabbing = true
	pokeTimer = 0
	hitbox.disabled = false
	pass
	
func stab_over():
	end_use_weapon()
	pullingBack = false
	pulledBack = false
	stabbing = false
	pokeTimer = 0
	hitbox.disabled = true
	pass
	
func end_use_weapon():
	super.end_use_weapon()
	pass
	
func quit_use_weapon():
	super.quit_use_weapon()
	if pullingBack || pulledBack:
		start_stab()
	pass
	
func apply_stats():
	super.apply_stats()
	
	poke_length = range * BASE_POKE_LENGTH
	
	damage = BASE_DAMAGE
	cooldown = BASE_COOLDOWN
	attackspeed = BASE_ATTACKSPEED
	duration = BASE_DURATION
	size = BASE_SIZE
	knockback = BASE_KNOCKBACK
	pass

func hit_entity(body: Node2D):
	super.hit_entity(body)
	pass
	
func apply_attack(entity: Entity):
	super.apply_attack(entity)
	entity.hurt(damage, knockback, Vector2.RIGHT.rotated(global_rotation - deg_to_rad(45 * global_scale.y)))
	pass
	
func unequip():
	super.unequip()
	hitbox.disabled = true
	pass
