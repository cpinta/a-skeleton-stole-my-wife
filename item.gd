extends Element
class_name Item

@export var ownerEntity: Entity
@export var collider: CollisionObject2D
@export var onGround: bool = false

@export var STORE_ANGLE: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
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
	pass
	
func drop():
	ownerEntity = null
	pass
