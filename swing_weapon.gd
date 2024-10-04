extends Weapon
class_name SwingWeapon

@export var FRONT_FACING_ANGLE = 45 #DO NOT CHANGE IN INHERITERS

@export var INHAND_ANGLE = 0

@export var SWING_DURATION = 1
@export var SWING_ARC_ANGLE = 90
@export var SWING_START_ANGLE: float
@export var SWING_END_ANGLE: float

@export var curSwingTime: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SWING_START_ANGLE = FRONT_FACING_ANGLE - (SWING_ARC_ANGLE/2)
	SWING_END_ANGLE = FRONT_FACING_ANGLE + (SWING_ARC_ANGLE/2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _physics_process(delta):
	super._physics_process(delta)
	if inUse:
		if curSwingTime < SWING_DURATION:
			rotation += SWING_START_ANGLE + ((curSwingTime/SWING_DURATION) * SWING_END_ANGLE)
			curSwingTime += delta
		else:
			stop_use_weapon()
	pass

func use_weapon():
	super.use_weapon()
	swing()
	pass
	
func stop_use_weapon():
	super.stop_use_weapon()
	rotation = INHAND_ANGLE
	pass

func swing():
	rotation = SWING_START_ANGLE
	curSwingTime = 0
	pass
