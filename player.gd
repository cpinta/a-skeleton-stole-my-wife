extends Entity
class_name Player

enum HandToUse {LEFT = 0, RIGHT = 1}

var lineMouseAim : Line2D
var aimPoint : Vector2
var arm : Node2D
var hand : Node2D
var handInner : Node2D
var back : Node2D
var body : Node2D

@export var DASH_SPEED := 125
@export var HAND_DISTANCE: float = 10
@export var ARM_OFFSET: Vector2

@export var weapons: Array[Weapon]
@export var curWeaponIndex: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	rb.collision_mask = 3
	
	BASE_MOVEMENT_ACCELERATION = 500
	BASE_MOVEMENT_MAX_SPEED = 100
	
	lineMouseAim = $"rb/body/debug/aimline"
	lineMouseAim.add_point(Vector2.ZERO)
	lineMouseAim.add_point(Vector2.ZERO)
	
	anim.play("idle")
	
	hand = $rb/body/hand
	handInner = hand.get_node("inner")
	back = $rb/body/back
	body = $rb/body
	
	
	#debug variables
	weapons.append(hand.get_node("Sceptre"))
	weapons.append(back.get_node("pistol"))
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input_vector()
	
	if Input.is_action_pressed("jump"):
		pass
	if Input.is_action_just_pressed("dash"):
		velocity = inputVector * DASH_SPEED
		pass
	if Input.is_action_just_pressed("shoot_left"):
		using_weapon(HandToUse.LEFT)
	if Input.is_action_just_released("shoot_left"):
		stop_using_weapon(HandToUse.LEFT)
	if Input.is_action_just_pressed("shoot_right"):
		using_weapon(HandToUse.RIGHT)
	if Input.is_action_just_released("shoot_right"):
		stop_using_weapon(HandToUse.RIGHT)
	
	lineMouseAim.points[1] = get_global_mouse_position() - rb.global_position
	aimPoint = lineMouseAim.points[1]
	
	pass
	
func using_weapon(hand: HandToUse):
	if not weapons[hand] == null:
		if hand != curWeaponIndex:
			swap_weapons()
		weapons[hand].use_weapon()
	pass
	
func stop_using_weapon(hand: HandToUse):
	if not weapons[hand] == null:
		if weapons[hand].inUse:
			weapons[hand].quit_use_weapon()
	pass
	
func swap_weapons():
	var handWeapon: Weapon = handInner.get_child(1)
	var backWeapon: Weapon = back.get_child(0)
	
	if backWeapon != null:
		backWeapon.reparent(hand)
		backWeapon.equip()
		pass
	if handWeapon != null:
		handWeapon.reparent(back)
		handWeapon.unequip()
		pass
		
	curWeaponIndex = HandToUse.RIGHT if curWeaponIndex == HandToUse.LEFT else HandToUse.LEFT
	
func _physics_process(delta):
	super._physics_process(delta)
	hand.look_at(get_global_mouse_position())
	hand.global_position = hand.global_position.lerp(rb.global_position + hand.transform.x * min(HAND_DISTANCE, (get_global_mouse_position() - rb.global_position).length()), 0.9)
	hand.rotate(-(PI/2))
	if hand.global_position.x > rb.global_position.x:
		anim.flip_h = false
		back.scale.y = 1
		back.rotation = 0
		handInner.scale.y = 1
		handInner.rotation = 0
	else:
		anim.flip_h = true
		back.scale.y = -1
		back.rotation = -PI
		handInner.scale.y = -1
		handInner.rotation = -PI
		
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
