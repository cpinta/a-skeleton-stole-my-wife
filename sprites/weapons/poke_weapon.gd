extends Weapon
class_name PokeWeapon

@export var area: Area2D
@export var hitbox: CollisionShape2D

@export var BASE_POKE_LENGTH: float = 20
@export var BASE_PULLBACK_LENGTH: float = 20
@export var BASE_PULLBACK_TIME: float = 0.25
@export var BASE_POKE_TIME: float = 0.25

@export var poke_length: float = 20
@export var pullback_length: float = 20
@export var pullback_time: float = 0.25
@export var poke_time: float = 0.25

@export var NEUTRAL_POSITION: float = 0

@export var pullingBack: bool = false
@export var pulledBack: bool = false
@export var pokeTimer: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	area = $"collider"
	area.connect("body_entered", hit_entity)
	hitbox = area.get_node("shape")
	hitbox.disabled = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	super._physics_process(delta)
	if inUse:
		if pullingBack || pulledBack:
			if pokeTimer < pullback_time:
				position.x = NEUTRAL_POSITION + ((pokeTimer/pullback_time) * (NEUTRAL_POSITION - pullback_length)) 
				pokeTimer += delta
			else:
				if not pulledBack:
					pulled_back()
				position.x = -pullback_length
		else:
			if pokeTimer < poke_time:
				position.x = (NEUTRAL_POSITION - pullback_length) + ((pokeTimer/poke_time) * (poke_length + pullback_length)) 
			else:
				position.x = -pullback_length
	else:
		position = position.lerp(Vector2(NEUTRAL_POSITION, 0), 0.5 * delta)
		pass
	pass

func use_weapon():
	var willPullback: bool = false
	if not inUse:
		willPullback = true
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
	pass
	
func start_stab():
	pullingBack = false
	pulledBack = false
	pass
	
func stab_over():
	end_use_weapon()
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
	entity.hurt(damage, knockback, Vector2.RIGHT.rotated(global_rotation))
	pass
	
func unequip():
	super.unequip()
	hitbox.disabled = true
	pass
