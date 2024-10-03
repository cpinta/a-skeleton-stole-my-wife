extends Node2D
class_name Entity

var anim : AnimatedSprite2D
var rb : CharacterBody2D

@export var WALK_ACCELERATION := 250
@export var MAX_WALK_SPEED := 100
@export var DECCELERATION := 200

@export var MAX_COLLISIONS := 6

@export var velocity := Vector2.ZERO

@export var usesDefaultMovement := true

@export var STARTING_HEALTH : int = 5
@export var health : int

# Called when the node enters the scene tree for the first time.
func _ready():
	WALK_ACCELERATION = 500
	MAX_WALK_SPEED = 100
	rb = $rb
	anim = $rb/animation
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if usesDefaultMovement:
		collision(delta)
		if velocity.length() > MAX_WALK_SPEED:
			velocity = velocity.normalized() * MAX_WALK_SPEED
		
		if velocity.length() > 0:
			var diff = velocity.length() - (DECCELERATION * delta)
			if diff > 0:
				velocity = (diff) * velocity.normalized()
			else:
				velocity = Vector2.ZERO

func collision(delta: float):
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
	velocity = amount * direction
	pass
