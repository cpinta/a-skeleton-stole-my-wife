extends Element
class_name Item

@export var ownerEntity: Entity
@export var collider: CollisionObject2D
@export var onGround: bool = false
@export var pickedUp: bool = false

@export var STORE_ANGLE: int = 0

@export var pickupArea: Area2D
@export var pickupBox: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pickupArea = $"pickup"
	pickupBox = pickupArea.get_node("shape")
	pickupBox.disabled = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if onGround:
		rotation_degrees = STORE_ANGLE
	pass
	
func on_ground():
	onGround = true
	pass

func pickup(entity : Entity):
	ownerEntity = entity
	pickedUp = true
	pickupBox.disabled = true
	pass
	
func drop():
	ownerEntity = null
	pickedUp = false
	pickupBox.disabled = false
	pass
