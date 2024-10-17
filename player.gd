extends Entity
class_name Player

enum HandToUse {LEFT = 0, RIGHT = 1}

var lineMouseAim : Line2D
var aimPoint : Vector2
var arm : Node2D
var hand : Node2D
var handInner : Node2D
var back : Node2D
var face : Node2D

var faceAnim: AnimatedSprite2D 
var FACE_ORIGIN: Vector2
var FACE_ANIM_MAX_FACE_DIST: float = 1.1
var FACE_ANIM_MAX_MOUSE_DIST: float = 50

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
	BASE_MOVEMENT_ACCELERATION = 500
	BASE_MOVEMENT_MAX_SPEED = 100
	
	anim.play("idle")
	
	hand = body.get_node("hand")
	handInner = hand.get_node("inner")
	back = body.get_node("back")
	face = body.get_node("face")
	faceAnim = face.get_node("animation")
	FACE_ORIGIN = face.position
	
	pickupArea = body.get_node("pickup")
	pickupArea.connect("area_entered", entered_pickup_area)
	pickupArea.connect("area_exited", exited_pickup_area)
	
	
	lineMouseAim = body.get_node("debug/aimline")
	lineMouseAim.add_point(Vector2.ZERO)
	lineMouseAim.add_point(Vector2.ZERO)
	
	entity_height = 25
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
	if Input.is_action_just_released("drop"):
		drop_key()
	
	lineMouseAim.points[1] = get_global_mouse_position() - rb.global_position
	aimPoint = lineMouseAim.points[1]
	
	if velocity.length() > 0.1:
		anim.play("walk")
	else:
		anim.play("idle")
		
	face_anim_process()
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
	
func drop_key():
	if weapons[currentHand] != null:
		drop_weapon(weapons[currentHand])
	pass
	
func drop_weapon(weapon: Weapon):
	var index = weapons.find(weapon)
	if index != -1:
		print(weapon.global_position.y," ",rb.global_position.y," ", abs(weapon.global_position.y - rb.global_position.y))
		weapon.reparent(self.owner, true)
		weapon.drop(abs(weapon.global_position.y - rb.global_position.y))
		#weapon.global_position = Vector2(weapon.global_position.x, rb.global_position.y)

		weapons[index] = null
	pass

func equip_weapon(weapon: Weapon):
	var index = get_first_open_weapon_slot()
	if index == -1:
		drop_weapon(weapons[currentHand])
		weapons[currentHand] = weapon
		weapon.reparent(handInner, false)
		weapons[currentHand].equip()
	else:
		if weapons[currentHand] != null:
			swap_weapons()
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

func face_anim_process():
	#sync faceAnim with anim
	faceAnim.play(anim.animation)
	faceAnim.set_frame_and_progress(anim.get_frame(), 0)
	faceAnim.flip_h = anim.flip_h
	
	var mouseDist: float = get_global_mouse_position().distance_to(body.global_position + FACE_ORIGIN)
	var faceAnimVector: Vector2 = (get_global_mouse_position() - FACE_ORIGIN).normalized() * (FACE_ANIM_MAX_FACE_DIST * min(mouseDist, FACE_ANIM_MAX_MOUSE_DIST)/FACE_ANIM_MAX_MOUSE_DIST)
	
	face.position = Vector2(FACE_ORIGIN.x * face.global_scale.y, FACE_ORIGIN.y) + faceAnimVector 
	print(min(mouseDist, FACE_ANIM_MAX_MOUSE_DIST)/FACE_ANIM_MAX_MOUSE_DIST)
	pass
