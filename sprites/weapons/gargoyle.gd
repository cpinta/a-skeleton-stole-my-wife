extends Enemy
class_name Gargoyle

enum GargoyleState {FLYING = 0, TURNING_TO_STONE = 1, STONE = 2}

var state: GargoyleState = GargoyleState.FLYING

var FLY_BOB_SPEED: float = 5
var FLY_TIME: float = 0.5
var currentTimer: float = 0

var TRANSFORM_TIME: float = 0.25
var ON_GROUND_TIME: float = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	FOLLOWS_PLAYER = true
	USES_DEFAULT_ANIMATIONS = false
	isAffectedByHeight = true
	DOES_HEIGHT_USE_GRAVITY = false
	
	
	BASE_MOVEMENT_MAX_SPEED = 30
	BASE_MOVEMENT_ACCELERATION = 10
	
	
	height = 75

	anim.play("fly")
	#anim.connect("animation_finished", anim_done)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass
	
func _physics_process(delta):
	super._physics_process(delta)
	match state:
		GargoyleState.FLYING:
			anim.play("fly")
			if anim.get_frame() == 0:
				height -= delta * FLY_BOB_SPEED
			else:
				height += delta * FLY_BOB_SPEED
			pass
		GargoyleState.TURNING_TO_STONE:
			anim.play("transform")
			pass
		GargoyleState.STONE:
			anim.play("stone")
			
			pass
	pass
