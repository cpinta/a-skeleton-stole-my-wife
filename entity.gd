extends Element
class_name Entity

enum Direction {LEFT = -1, RIGHT = 1}

var anim : AnimatedSprite2D
var rb : CharacterBody2D
var col : CollisionShape2D

@export var BASE_ATTACK_DAMAGE: float = 1
@export var BASE_ATTACK_COOLDOWN: float = 1
@export var BASE_ATTACK_SPEED: float = 1
@export var BASE_ATTACK_DURATION: float = 1
@export var BASE_ATTACK_SIZE: float = 1
@export var BASE_ATTACK_KNOCKBACK: float = 1

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

@export var movement_max_speed: float = 1
@export var movement_acceleration: float = 1
@export var movement_decceleration: float = 1
@export var dash_speed: float = 1
@export var size: float = 1



@export var MAX_COLLISIONS := 6

@export var inputVector := Vector2.ZERO
@export var velocity := Vector2.ZERO
@export var facingDirection := Direction.RIGHT	#The direction the entity's sprite is facing: left or right. Set using set_direction
@export var canWalk := true

@export var USES_DEFAULT_MOVEMENT := true
@export var USES_DEFAULT_ANIMATIONS := true
@export var MIN_SPEED_TO_ANIM: float = 1

@export var STARTING_HEALTH : int = 5
@export var health : int

var statusEffects: Array[StatusEffect]

# Called when the node enters the scene tree for the first time.
func _ready():
	rb = $rb
	anim = $rb/animation
	health = STARTING_HEALTH
	set_default_stats()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if USES_DEFAULT_ANIMATIONS:
		if canWalk:
			if velocity.length() > MIN_SPEED_TO_ANIM:
				anim.play("walk")
			else:
				anim.play("idle")
	pass

func _physics_process(delta):
	if statusEffects.size() > 0:
		apply_effects(delta)
	else:
		set_default_stats()
	if USES_DEFAULT_MOVEMENT:
		collide(delta)
		if velocity.length() > movement_max_speed:
			velocity = velocity * (0.99)
		
		if velocity.length() > 0:
			var diff = velocity.length() - (movement_decceleration * delta)
			if diff > 0:
				velocity = (diff) * velocity.normalized()
			else:
				velocity = Vector2.ZERO
		
		if not velocity.length() > movement_max_speed:
			velocity += inputVector * movement_acceleration * delta

func collide(delta: float):
	var collision_count := 0
	var collision = rb.move_and_collide(-Vector2(velocity.x, velocity.y) * delta)
	while collision and collision_count < MAX_COLLISIONS:
		var collider = collision.get_collider()
		
		if collider is Player:
			#collider.hit(DAMAGE)
			#queue.free()
			break
		else:
			var normal = collision.get_normal()
			var remainder = collision.get_remainder()
			var angle = collision.get_angle()
			velocity = Vector2(velocity.x + (-1 * abs(normal.x) * velocity.x), velocity.y + (-1 * abs(normal.y) * velocity.y))
			remainder = Vector2(remainder.x + (-1 * abs(normal.x) * remainder.x), remainder.y + (-1 * abs(normal.y) * remainder.y))
			
			collision_count += 1
			collision = rb.move_and_collide(remainder)
	pass
	
func attack_enemy(entity: Entity, damage: int, knock_amount: int = 0, knock_direction: Vector2 = Vector2.ZERO):
	entity.hurt(damage, knock_amount, knock_direction)
	pass

func hurt(damage: int, knock_amount: int = 0, knock_direction: Vector2 = Vector2.ZERO):
	health -= damage
	if health < 1:
		was_killed()
	else:
		apply_knockback(knock_amount, knock_direction)
	pass
	
func was_killed():
	queue_free()
	pass
	
func apply_knockback(amount: int, direction: Vector2):
	velocity = -amount * direction
	pass
	
func set_direction(dir: Direction):
	facingDirection = dir
	if dir == Direction.LEFT:
		anim.flip_h = false
	if dir == Direction.RIGHT:
		anim.flip_h = true
		
func global_position():
	return rb.global_position

func apply_effects(delta):
	set_default_stats()
	for effect in statusEffects:
		var timeLeft: float = effect.apply(delta, self)
		if timeLeft < 0:
			statusEffects.erase(effect)
		pass
	pass
	
func set_default_stats():
	movement_max_speed = BASE_MOVEMENT_MAX_SPEED
	movement_acceleration = BASE_MOVEMENT_ACCELERATION
	movement_decceleration = BASE_DECCELERATION
	dash_speed = BASE_DASH_SPEED
	size = BASE_SIZE
	
	attack_damage = BASE_ATTACK_DAMAGE
	attack_cooldown = BASE_ATTACK_COOLDOWN
	attack_speed = BASE_ATTACK_SPEED
	attack_duration = BASE_ATTACK_DURATION
	attack_size = BASE_ATTACK_SIZE
	attack_knockback = BASE_ATTACK_KNOCKBACK
	pass

func add_status_effect(effect: StatusEffect):
	statusEffects.append(effect)
	apply_effects(0)
	pass
