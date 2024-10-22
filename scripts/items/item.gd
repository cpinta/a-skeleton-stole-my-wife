extends Node2D
class_name Item

@export var ownerEntity: Entity
@export var collider: CollisionObject2D
@export var elementHeight: HeightElement
@export var anim: AnimatedSprite2D
@export var onGround: bool = false
@export var pickedUp: bool = false


@export var STORE_ANGLE: int = 0

@export var pickupArea: Area2D
@export var pickupBox: CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	elementHeight = $animation
	
	pickupArea = $"pickup"
	pickupBox = pickupArea.get_node("shape")
	
	drop(5)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if onGround:
		rotation_degrees = STORE_ANGLE
	pass
	
func _physics_process(delta):
	if not pickedUp:	
		elementHeight.isAffectedByHeight = true
			
		#if abs(rotation_degrees - STORE_ANGLE) < 5:
			#rotation_degrees = STORE_ANGLE
		#else:
			#if rotation_degrees > STORE_ANGLE:
				#rotation_degrees -= delta * 50
			#else:
				#rotation_degrees += delta * 50
		
	pass
	
func on_ground():
	onGround = true
	pass

func pickup(entity : Entity):
	ownerEntity = entity
	pickedUp = true
	pickupBox.disabled = true
	elementHeight.unload_shadow()
	pass
	
func drop(height: float):
	ownerEntity = null
	pickedUp = false
	pickupBox.disabled = false
	elementHeight.load_shadow()
	elementHeight.height = height
	global_position.y += height
	rotation_degrees = STORE_ANGLE
	scale.y = 1
	#rotation = 0
	
	pass
