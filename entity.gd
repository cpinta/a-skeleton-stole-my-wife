extends Element
class_name Entity

enum Direction {LEFT = -1, RIGHT = 1}

var anim : AnimatedSprite2D
var rb : CharacterBody2D
var col : CollisionShape2D

@export var WALK_ACCELERATION := 250
@export var MAX_WALK_SPEED := 100
@export var DECCELERATION := 200

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

# Called when the node enters the scene tree for the first time.
func _ready():
	WALK_ACCELERATION = 500
	MAX_WALK_SPEED = 100
	rb = $rb
	anim = $rb/animation
	health = STARTING_HEALTH
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
	if USES_DEFAULT_MOVEMENT:
		collide(delta)
		if velocity.length() > MAX_WALK_SPEED:
			velocity = velocity * (0.99)
		
		if velocity.length() > 0:
			var diff = velocity.length() - (DECCELERATION * delta)
			if diff > 0:
				velocity = (diff) * velocity.normalized()
			else:
				velocity = Vector2.ZERO
		
		if not velocity.length() > MAX_WALK_SPEED:
			velocity += inputVector * WALK_ACCELERATION * delta

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
