extends PokeWeapon
class_name Sceptre

var inSchoolZone := true
var currentSpeed = 65
var currentSpeedLimit = 25
var MAX_SLOWDOWN_RATE = 10
var MAX_ACCELERATION = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if inSchoolZone:
		if currentSpeed > currentSpeedLimit:
			currentSpeed -= MAX_SLOWDOWN_RATE * delta
		else:
			currentSpeed = currentSpeedLimit
	else:
		currentSpeed += MAX_ACCELERATION * delta

# Called when the node enters the scene tree for the first time.
func _ready():
	weaponName = "Corn Stalk"
	description = "Stalk up or stalk out."
	BASE_DAMAGE = 0
	BASE_KNOCKBACK = 75
	BASE_DURATION = 0.25
	BASE_COOLDOWN = 0.1
	
	EQUIP_ANGLE = 180
	STORE_ANGLE = -45
	
	collider = $collider
	
	super._ready()
	pass # Replace with function body.
