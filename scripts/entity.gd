extends CharacterBody2D
class_name Entity

enum Direction {LEFT = -1, RIGHT = 1}

var rb : CharacterBody2D
var anim : AnimatedSprite2D
var col : CollisionShape2D
var body : Node2D
var elementHeight: HeightElement

@export var BASE_ATTACK_DAMAGE: float = 1
@export var BASE_ATTACK_COOLDOWN: float = 1
@export var BASE_ATTACK_SPEED: float = 1
@export var BASE_ATTACK_DURATION: float = 1
@export var BASE_ATTACK_SIZE: float = 1
@export var BASE_ATTACK_KNOCKBACK: float = 1
@export var BASE_ATTACK_RANGE: float = 1
@export var BASE_ATTACK_HITSTUN: float = 0.25

@export var BASE_MOVEMENT_MAX_SPEED: float = 100
@export var BASE_MOVEMENT_ACCELERATION: float = 250
@export var BASE_DECCELERATION := 200
@export var BASE_DASH_SPEED: float = 125
@export var BASE_SIZE: float = 1

@export var attack_damage: float = 1
@export var attack_cooldown: float = 1
@export var attack_speed: float = 1
@export var attack_duration: float = 1
@export var attack_size: float = 1
@export var attack_knockback: float = 1
@export var attack_range: float = 1
@export var attack_hitstun: float = 0.1

@export var movement_max_speed: float = 1
@export var movement_acceleration: float = 1
@export var movement_decceleration: float = 1
@export var dash_speed: float = 1
@export var size: float = 1

@export var BASE_APPLY_POST_HIT_INVINC: bool = true
@export var POST_HIT_INVINCIBILITY_TIME: float = 0.1
@export var isHittable = true
@export var flickersWhenNotHittable = true

@export var MAX_COLLISIONS := 6

@export var inputVector := Vector2.ZERO
@export var entityVelocity := Vector2.ZERO
@export var facingDirection := Direction.RIGHT	#The direction the entity's sprite is facing: left or right. Set using set_direction
@export var canWalk := true
@export var BASE_CAN_MOVE := true
@export var canMove := true

@export var USES_DEFAULT_MOVEMENT := true
@export var USES_DEFAULT_ANIMATIONS := true
@export var MIN_SPEED_TO_ANIM: float = 1

@export var STARTING_HEALTH : int = 5
@export var health : int
@export var wasKilledLastFrame: bool = false

var statusEffects: Array[StatusEffect]
var attack_statusEffects: Array[StatusEffect]

var items: Array[Item]
@export var weapons: Array[Weapon]
@export var MAX_WEAPON_COUNT: int = 2
@export var ITEM_DROP_HEIGHT: float = 5

@export var animWalkName: String = "walk"
@export var animIdleName: String = "idle"

@export var score: int = 0
@export var combo: EntityCombo

# Called when the node enters the scene tree for the first time.
func _ready():
	rb = self
	body = $body
	anim = body.get_node("animation")
	elementHeight = anim
	health = STARTING_HEALTH
	weapons.append(null)
	weapons.append(null)
	set_default_stats()
	
	combo = get_node_or_null("combo")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if wasKilledLastFrame:
		was_killed()
	if USES_DEFAULT_ANIMATIONS:
		if canWalk:
			if entityVelocity.length() > MIN_SPEED_TO_ANIM:
				anim.play(animWalkName)
			else:
				anim.play(animIdleName)
	if not isHittable and flickersWhenNotHittable:
		anim.visible = not anim.visible
	pass

func _physics_process(delta):
	if statusEffects.size() > 0:
		apply_effects(delta)
	else:
		set_default_stats()
	if USES_DEFAULT_MOVEMENT:
		collide(delta)
		if entityVelocity.length() > movement_max_speed:
			entityVelocity = entityVelocity * (0.99)
		
		if entityVelocity.length() > 0:
			var diff = entityVelocity.length() - (movement_decceleration * delta)
			if diff > 0:
				entityVelocity = (diff) * entityVelocity.normalized()
			else:
				entityVelocity = Vector2.ZERO
		
		if not entityVelocity.length() > movement_max_speed:
			entityVelocity += (inputVector * int(canMove)) * movement_acceleration * delta

func collide(delta: float):
	var collision_count := 0
	var collision = move_and_collide(-Vector2(entityVelocity.x, entityVelocity.y) * delta)
	while collision and collision_count < MAX_COLLISIONS:
		var collider = collision.get_collider()
		var entity = collider.get_parent()
		if entity is Player:
			
			pass
		elif entity is Enemy:
			var enemy = entity as Enemy
			if self is Player:
				if enemy.DAMAGES_ON_CONTACT:
					enemy.attack_enemy(self, enemy.attack_damage, enemy.attack_knockback, self.global_position - enemy.global_position)
		var normal = collision.get_normal()
		var remainder = collision.get_remainder()
		var angle = collision.get_angle()
		entityVelocity = Vector2(entityVelocity.x + (-1 * abs(normal.x) * entityVelocity.x), entityVelocity.y + (-1 * abs(normal.y) * entityVelocity.y))
		remainder = Vector2(remainder.x + (-1 * abs(normal.x) * remainder.x), remainder.y + (-1 * abs(normal.y) * remainder.y))
		
		collision_count += 1
		collision = rb.move_and_collide(remainder)
	pass
	
func apply_attack_to_entity(entity: Entity):
	for effect in attack_statusEffects:
		effect.target = entity
	if entity.hurt(attack_damage, attack_knockback, (entity.global_position - global_position).normalized(), BASE_APPLY_POST_HIT_INVINC, attack_statusEffects):
		add_combo(entity.STARTING_HEALTH)
	pass
	
func add_combo(value: int):
	if combo != null:
		combo.add()
		calculate_score_addition(value)
		pass
	pass
	
func calculate_score_addition(value):
	var scoreAdd = value * combo.get_multiplier()
	score += scoreAdd
	pass

func hurt(damage: int, knock_amount: int = 0, knock_direction: Vector2 = Vector2.ZERO, apply_post_hit_invinc: bool = true, statusEffects: Array[StatusEffect] = []):
	if not isHittable:
		return false
	health -= damage
	if combo != null:
		combo.drop()
	if health < 1:
		wasKilledLastFrame = true
		if statusEffects.size() > 0:
			add_status_effects(statusEffects)
	else:
		apply_knockback(knock_amount, knock_direction)
		if apply_post_hit_invinc:
			add_status_effect(SE_Invincibility.new(self, POST_HIT_INVINCIBILITY_TIME))
			isHittable = true
		if statusEffects.size() > 0:
			add_status_effects(statusEffects)
	return true
	pass
	
func was_killed():
	apply_effects(0)
	queue_free()
	pass
	
func apply_knockback(amount: int, direction: Vector2):
	entityVelocity = -amount * direction
	pass
	
func set_direction(dir: Direction):
	facingDirection = dir
	if dir == Direction.LEFT:
		pass
	if dir == Direction.RIGHT:
		pass

func apply_effects(delta):
	set_default_stats()
	for effect in statusEffects:
		var timeLeft: float = await effect.apply(delta)
		if timeLeft < 0:
			effect.was_removed()
			statusEffects.erase(effect)
		pass
	pass
	
func set_default_stats():
	movement_max_speed = BASE_MOVEMENT_MAX_SPEED
	movement_acceleration = BASE_MOVEMENT_ACCELERATION
	movement_decceleration = BASE_DECCELERATION
	dash_speed = BASE_DASH_SPEED
	size = BASE_SIZE
	canMove = BASE_CAN_MOVE
	
	attack_damage = BASE_ATTACK_DAMAGE
	attack_cooldown = BASE_ATTACK_COOLDOWN
	attack_speed = BASE_ATTACK_SPEED
	attack_duration = BASE_ATTACK_DURATION
	attack_size = BASE_ATTACK_SIZE
	attack_knockback = BASE_ATTACK_KNOCKBACK
	attack_range = BASE_ATTACK_RANGE
	attack_hitstun = BASE_ATTACK_HITSTUN
	pass

func add_status_effect(effect: StatusEffect):
	statusEffects.append(effect)
	apply_effects(0)
	pass
	
func add_status_effects(effects: Array[StatusEffect]):
	statusEffects.append_array(effects)
	apply_effects(0)
	pass
	
func pickup(item: Item):
	item.pickup(self)
	pass

func get_weapon_count():
	var count: int = 0
	if(weapons[0] != null):
		count += 1
	if(weapons[1] != null):
		count += 1
	return count
	
func get_first_open_weapon_slot():
	if(weapons[0] == null):
		return 0
	if(weapons[1] == null):
		return 1
	return -1
