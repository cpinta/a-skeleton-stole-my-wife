extends Entity
class_name Player

enum HandToUse {LEFT = 0, RIGHT = 1}
enum Gender {HOMIE=0, HOMETTE=1}

var gender : Gender

var aimPoint : Vector2
var arm : Node2D
var hand : Node2D
var handInner : Node2D
var back : Node2D
var face : Node2D

var faceAnim: AnimatedSprite2D 
var FACE_ORIGIN: Vector2
var FACE_ANIM_MAX_FACE_DIST: float = 1
var FACE_ANIM_MAX_MOUSE_DIST: float = 50

var pickupArea: Area2D

@export var DASH_SPEED := 125
@export var HAND_MAX_DISTANCE: float = 10
@export var HAND_ORIGIN: Vector2
@export var HAND_HEIGHT: float = 12
@export var ARM_OFFSET: Vector2

@export var currentHand: HandToUse = HandToUse.LEFT

@export var availableInteractables: Array[Interactable]
@export var closestInteract: Interactable

@export var allowInput: bool = true

signal justDied

# Called when the node enters the scene tree for the first time.
func _ready():
	STARTING_HEALTH = 20
	super._ready()
	allowInput = false
	BASE_MOVEMENT_ACCELERATION = 500
	BASE_MOVEMENT_MAX_SPEED = 50
	
	#USES_DEFAULT_ANIMATIONS = true
	
	hand = body.get_node("hand")
	handInner = hand.get_node("inner")
	back = body.get_node("back")
	face = body.get_node("face")
	
	if gender == Gender.HOMIE:
		anim = body.get_node("animationm")
		faceAnim = face.get_node("animationm")
		$body/animationf.visible = false
		$body/face/animationf.visible = false
	else:
		anim = body.get_node("animationf")
		faceAnim = face.get_node("animationf")
		$body/animationm.visible = false
		$body/face/animationm.visible = false
	elementHeight = anim
	anim.play("idle")
	
	FACE_ORIGIN = face.position
	
	pickupArea = body.get_node("pickup")
	pickupArea.connect("area_entered", entered_interact_area)
	pickupArea.connect("area_exited", exited_interact_area)
	
	elementHeight.entity_height = 25
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if allowInput:
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
	
	if entityVelocity.length() > 0.1:
		anim.play("walk")
	else:
		anim.play("idle")
		
	find_closest_interact()
		
	face_anim_process()
	pass
	
func use_weapon(hand: HandToUse):
	if weapons[hand] != null:
		if weapons[currentHand] != null:
			if not weapons[currentHand].inUse:
				if hand != currentHand:
					swap_weapons()
				weapons[hand].use_weapon()
		else:
			swap_weapons()
			weapons[hand].use_weapon()
				
func stop_use_weapon(hand: HandToUse):
	if not weapons[hand] == null:
		if weapons[hand].inUse:
			weapons[hand].quit_use_weapon()
	pass
	
func swap_weapons():
	var handWeapon: Weapon
	var backWeapon: Weapon
	if handInner.get_child_count() > 1:
		handWeapon= handInner.get_child(1)
	if back.get_child_count() > 0:
		backWeapon= back.get_child(0)
	
	if backWeapon != null:
		backWeapon.reparent(handInner)
		backWeapon.equip()
	if handWeapon != null:
		handWeapon.reparent(back)
		handWeapon.unequip()
		
	currentHand = HandToUse.RIGHT if currentHand == HandToUse.LEFT else HandToUse.LEFT
	
func dash():
	entityVelocity = inputVector * DASH_SPEED
	
func _physics_process(delta):
	super._physics_process(delta)
	hand.position = back.position
	hand.look_at(get_global_mouse_position())
	var handDistance: float = min(HAND_MAX_DISTANCE, (get_global_mouse_position() - global_position).length())
	hand.global_position = hand.global_position.lerp(global_position - Vector2(0, HAND_HEIGHT) + hand.transform.x * handDistance, 1)
	hand.rotate(-(PI/2))
	if hand.global_position.x > global_position.x:
		set_direction(Direction.RIGHT)
	else:
		set_direction(Direction.LEFT)
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
	if availableInteractables.size() > 0:
		if closestInteract is Weapon:
			if weapons.size() < 2:
				pickup(closestInteract)
				drop_weapon(weapons[currentHand])
				equip_weapon(closestInteract)
			else:
				pickup(closestInteract)
				equip_weapon(closestInteract)
		else:
			closestInteract.try_interact(self)
	pass
	
func drop_key():
	if weapons[currentHand] != null:
		if not weapons[currentHand].inUse:
			drop_weapon(weapons[currentHand])
	pass
	
func drop_weapon(weapon: Weapon):
	var index = weapons.find(weapon)
	if index != -1:
		print(weapon.global_position.y," ",global_position.y," ", abs(weapon.global_position.y - global_position.y))
		if weapon.attack_hit.is_connected(our_attack_did_hit):
			weapon.attack_hit.disconnect(our_attack_did_hit)
			pass
		if weapon.inUse:
			weapon.end_use_weapon()
		weapon.reparent(Game.currentLvl, true)
		weapon.drop(abs(weapon.global_position.y - global_position.y))
		#weapon.global_position = Vector2(weapon.global_position.x, global_position.y)

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
	if not weapon.attack_hit.is_connected(our_attack_did_hit):
		weapon.attack_hit.connect(our_attack_did_hit)
		pass
	pass

func entered_interact_area(node: Node2D):
	var parent = node.get_parent()
	print("entered interact:",parent.name)
	if parent != null:
		if parent is Interactable:
			var interact = parent as Interactable
			if not availableInteractables.has(interact):
				availableInteractables.append(interact)
				find_closest_interact()
	pass
	
func exited_interact_area(node: Node2D):
	var parent = node.get_parent()
	print("exited interact:",parent.name)
	if parent != null:
		if parent is Interactable:
			var interact = parent as Interactable
			if availableInteractables.has(interact):
				interact.not_closest_interact()
				availableInteractables.erase(interact)
				if closestInteract == interact:
					find_closest_interact()
	pass
	
func find_closest_interact():
	if not allowInput:
		return
	if availableInteractables.size() > 1:
		var shortestDistance: float = 999999
		var closestInteract: Interactable = null
		for pickup in availableInteractables:
			var interactDistance = global_position.distance_to(pickup.global_position)
			if interactDistance < shortestDistance:
				shortestDistance = interactDistance
				closestInteract = pickup
			pass
		set_as_closest_interact(closestInteract)
	elif availableInteractables.size() == 1:
		set_as_closest_interact(availableInteractables[0])
	else:
		closestInteract = null

func set_as_closest_interact(interact: Interactable):
	if closestInteract != null:
		closestInteract.not_closest_interact()
	closestInteract = interact
	closestInteract.is_closest_interact()
	pass

func set_direction(dir: Direction):
	facingDirection = dir
	if dir == Direction.LEFT:
		anim.flip_h = true
		back.scale.y = -1
		back.rotation = -PI
		handInner.scale.y = -1
		handInner.rotation = -PI
		pass
	if dir == Direction.RIGHT:
		anim.flip_h = false
		back.scale.y = 1
		back.rotation = 0
		handInner.scale.y = 1
		handInner.rotation = 0
		pass

func was_killed():
	apply_effects(0)
	isDead = true
	allowInput = false
	inputVector = Vector2.ZERO
	justDied.emit()

func set_gender(gender:Gender):
	if gender == Gender.HOMIE:
		
		pass
	else:
		
		pass
	pass

func face_anim_process():
	#sync faceAnim with anim
	faceAnim.play(anim.animation)
	faceAnim.set_frame_and_progress(anim.get_frame(), 0)
	faceAnim.flip_h = anim.flip_h
	
	var mouseDist: float = get_global_mouse_position().distance_to(body.global_position + FACE_ORIGIN)
	var faceAnimVector: Vector2 = (get_global_mouse_position() - FACE_ORIGIN).normalized() * (FACE_ANIM_MAX_FACE_DIST * min(mouseDist, FACE_ANIM_MAX_MOUSE_DIST)/FACE_ANIM_MAX_MOUSE_DIST)
	
	var xoffset: int = 1 if facingDirection == Direction.RIGHT else 0
	face.position = Vector2(FACE_ORIGIN.x + (facingDirection * xoffset), FACE_ORIGIN.y) + faceAnimVector 
	#print(str(Vector2(FACE_ORIGIN.x + (facingDirection * xoffset), FACE_ORIGIN.y) + faceAnimVector)+" bruh "+str(faceAnimVector))
	pass
