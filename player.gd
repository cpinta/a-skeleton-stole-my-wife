extends Entity
class_name Player

enum HandToUse {LEFT = 0, RIGHT = 1}

var lineMouseAim : Line2D
var aimPoint : Vector2
var arm : Node2D
var hand : Node2D
var handInner : Node2D
var back : Node2D

var pickupArea: Area2D

@export var DASH_SPEED := 125
@export var HAND_DISTANCE: float = 10
@export var HAND_HEIGHT: float = 12
@export var ARM_OFFSET: Vector2

@export var currentHand: HandToUse = HandToUse.LEFT

@export var availablePickups: Array[Item]


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	rb.collision_mask = 3
	
	BASE_MOVEMENT_ACCELERATION = 500
	BASE_MOVEMENT_MAX_SPEED = 100
	
	anim.play("idle")
	
	hand = body.get_node("hand")
	handInner = hand.get_node("inner")
	back = body.get_node("back")
	
	pickupArea = body.get_node("pickup")
	pickupArea.connect("area_entered", entered_pickup_area)
	pickupArea.connect("area_exited", exited_pickup_area)
	
	
	lineMouseAim = body.get_node("debug/aimline")
	lineMouseAim.add_point(Vector2.ZERO)
	lineMouseAim.add_point(Vector2.ZERO)
	
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input_vector()
	
	if Input.is_action_pressed("jump"):
		pass
	if Input.is_action_just_pressed("dash"):
		dash()
		pass
	if Input.is_action_just_pressed("shoot_left"):
		use_weapon(HandToUse.LEFT)
	if Input.is_action_just_released("shoot_left"):
		stop_use_weapon(HandToUse.LEFT)
	if Input.is_action_just_pressed("shoot_right"):
		use_weapon(HandToUse.RIGHT)
	if Input.is_action_just_released("shoot_right"):
		stop_use_weapon(HandToUse.RIGHT)
	if Input.is_action_just_released("interact"):
		interact()
	
	lineMouseAim.points[1] = get_global_mouse_position() - rb.global_position
	aimPoint = lineMouseAim.points[1]
	
	if velocity.length() > 0.1:
		anim.play("walk")
	else:
		anim.play("idle")
	
	pass
	
func use_weapon(hand: HandToUse):
	if weapons.size() > hand:
		if not weapons[hand] == null:
			if not weapons[currentHand].inUse:
				if hand != currentHand:
					swap_weapons()
				weapons[hand].use_weapon()
	
func stop_use_weapon(hand: HandToUse):
	if not weapons[hand] == null:
		if weapons[hand].inUse:
			weapons[hand].quit_use_weapon()
	pass
	
func swap_weapons():
	var handWeapon: Weapon = handInner.get_child(1)
	var backWeapon: Weapon = back.get_child(0)
	
	if backWeapon != null:
		backWeapon.reparent(handInner)
		backWeapon.equip()
	if handWeapon != null:
		handWeapon.reparent(back)
		handWeapon.unequip()
		
	currentHand = HandToUse.RIGHT if currentHand == HandToUse.LEFT else HandToUse.LEFT
	
func dash():
	velocity = inputVector * DASH_SPEED
	
func _physics_process(delta):
	super._physics_process(delta)
	hand.look_at(get_global_mouse_position())
	hand.global_position = hand.global_position.lerp(rb.global_position - Vector2(0, HAND_HEIGHT) + hand.transform.x * min(HAND_DISTANCE, (get_global_mouse_position() - rb.global_position).length()), 0.9)
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
		
func interact():
	if availablePickups.size() > 0:
		var shortestDistance: float = 0
		var closestItem: Item = availablePickups[0]
		for item in availablePickups:
			var itemDistance = rb.global_position.distance_to(item.global_position)
			if itemDistance > shortestDistance:
				shortestDistance = itemDistance
				closestItem = item
			pass
		if closestItem is Weapon:
			if weapons.size() < 2:
				pickup(closestItem)
				drop_weapon(weapons[currentHand])
				equip_weapon(closestItem)
			else:
				pickup(closestItem)
				equip_weapon(closestItem)
				
		
	pass
	
func drop_weapon(weapon: Weapon):
	if weapons.has(weapon):
		weapons.erase(weapon)
	pass

func equip_weapon(weapon: Weapon):
	if weapons.size() == 0:
		weapon.reparent(handInner, false)
		weapons.append(weapon)
		weapons[0].equip()
		weapons[0].equip()
		currentHand = HandToUse.LEFT
	elif weapons.size() == 1:
		swap_weapons()
		weapon.reparent(handInner, false)
		weapons[get_first_open_weapon_slot()].equip()
	elif weapons.size() == 2:
		drop_weapon(weapons[currentHand])
		weapons[currentHand] = weapon
		weapon.reparent(handInner, false)
		weapons[currentHand].equip()
	pass

func entered_pickup_area(node: Node2D):
	var parent = node.get_parent()
	print("entered pickup:",parent.name)
	if parent != null:
		if parent is Item:
			var item = parent as Item
			if not availablePickups.has(item):
				availablePickups.append(item)
	pass
	
func exited_pickup_area(node: Node2D):
	var parent = node.get_parent()
	print("exited pickup:",parent.name)
	if parent != null:
		if parent is Item:
			var item = parent as Item
			if availablePickups.has(item):
				availablePickups.erase(item)
	pass
