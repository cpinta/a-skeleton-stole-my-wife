extends Enemy
class_name Ghost

var FLOAT_HEIGHT = 10
var FLOAT_BOB_SPEED = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	STARTING_HEALTH = 4
	BASE_ATTACK_DAMAGE = 1
	super._ready()
	FOLLOWS_PLAYER = true
	
	animIdleName = "idle"
	animWalkName = "idle"
	BASE_MOVEMENT_MAX_SPEED = 10
	DAMAGES_ON_CONTACT = true
	
	elementHeight.isAffectedByHeight = true
	elementHeight.DOES_HEIGHT_USE_GRAVITY = false
	elementHeight.height = FLOAT_HEIGHT
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if anim.get_frame() == 0 or anim.get_frame() == 1:
		elementHeight.height -= delta * FLOAT_BOB_SPEED
	elif anim.get_frame() == 3 or anim.get_frame() == 4:
		elementHeight.height += delta * FLOAT_BOB_SPEED
	pass

func _physics_process(delta):
	super._physics_process(delta)
	rb.collision_layer = 0b0001000
	rb.collision_mask = 0b0
	pass
