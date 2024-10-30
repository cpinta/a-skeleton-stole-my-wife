extends Interactable
class_name Item

@export var ownerEntity: Entity
@export var collider: CollisionObject2D
@export var elementHeight: HeightElement
@export var anim: AnimatedSprite2D
@export var onGround: bool = false
@export var pickedUp: bool = false

@export var START_DROPPED: bool = true

@export var STORE_ANGLE: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	elementHeight = $animation
	
	if START_DROPPED:
		drop(5)
		
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
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
	disable_interact()
	ownerEntity = entity
	pickedUp = true
	elementHeight.unload_shadow()
	pass
	
func drop(height: float):
	enable_interact()
	ownerEntity = null
	pickedUp = false
	if elementHeight.shadow != null:
		elementHeight.unload_shadow()
	elementHeight.load_shadow()
	elementHeight.height = height
	global_position.y += height
	rotation_degrees = STORE_ANGLE
	scale.y = 1
	#rotation = 0
	pass
	
func add_to_inventory():
	pass
