extends Entity
class_name Player

enum HandToUse {LEFT = 0, RIGHT = 1}

var lineMouseAim : Line2D
var aimPoint : Vector2
var arm : Node2D
var hand : Node2D

@export var DASH_SPEED := 125
@export var HAND_DISTANCE: float = 0
@export var ARM_OFFSET: Vector2

@export var weapons: Array[Weapon]
@export var curWeaponIndex: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	rb.collision_mask = 3
	
	WALK_ACCELERATION = 500
	MAX_WALK_SPEED = 100
	
	lineMouseAim = $"rb/debug/aimline"
	lineMouseAim.add_point(Vector2.ZERO)
	lineMouseAim.add_point(Vector2.ZERO)
	
	anim.play("idle")
	
	arm = $rb/arm
	ARM_OFFSET = arm.position
	hand = $rb/arm/hand
	
	#debug variables
	weapons.append(hand.get_node("sledgehammer"))
	weapons.append(null)
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input_vector()
	
	if Input.is_action_pressed("jump"):
		pass
	if Input.is_action_just_pressed("dash"):
		velocity = inputVector * DASH_SPEED
		pass
	if Input.is_action_just_released("shoot_left"):
		if not weapons[HandToUse.LEFT] == null:
			weapons[HandToUse.LEFT].use_weapon()
		pass
	if Input.is_action_just_pressed("shoot_right"):
		if not weapons[HandToUse.RIGHT] == null:
			weapons[HandToUse.RIGHT].use_weapon()
		pass
	
	lineMouseAim.points[1] = get_global_mouse_position() - rb.global_position
	aimPoint = lineMouseAim.points[1]
	
	pass
	
func _physics_process(delta):
	super._physics_process(delta)
	arm.look_at(get_global_mouse_position())
	arm.rotate(-(PI/2))
	#arm.position = Vector2.RIGHT.rotated(arm.rotation)
	pass
	
func get_input_vector():
	inputVector = Vector2.ZERO
	if Input.is_action_pressed("left"):
		inputVector.x += 1
	if Input.is_action_pressed("right"):
		inputVector.x -= 1
	if Input.is_action_pressed("up"):
		inputVector.y += 1
	if Input.is_action_pressed("down"):
		inputVector.y -= 1
