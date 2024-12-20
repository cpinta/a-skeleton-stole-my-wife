extends Enemy
class_name Pumpkin

var IDLE_TIME: float = 0.2
var idle_timer: float = 0

var LAND_TIME: float = 0.01
var land_timer: float = 0

var JUMP_HEIGHT: float = 35

# Called when the node enters the scene tree for the first time.
func _ready():
	BASE_TOTAL_HEALTH = 8
	BASE_ATTACK_DAMAGE = 4
	super._ready()
	FOLLOWS_PLAYER = false
	DAMAGES_ON_CONTACT = false
	USES_DEFAULT_ANIMATIONS = false
	elementHeight.isAffectedByHeight = true
	BASE_MOVEMENT_MAX_SPEED = 35
	#elementHeight.GRAVITY = 20

	anim.play("idle")
	anim.connect("animation_finished", anim_done)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass
	
func _physics_process(delta):
	super._physics_process(delta)
	if elementHeight.wasJustOffGround:
		land()
	if elementHeight.heightOnGround:
		if land_timer < LAND_TIME:
			land_timer += delta
		else:
			anim.play("idle")
		if idle_timer < IDLE_TIME:
			idle_timer += delta
			inputVector = Vector2.ZERO
		else:
			jump()
	pass

func jump():
	elementHeight.heightVerticalSpeed = JUMP_HEIGHT
	velocity = velocity.normalized() * movement_max_speed
	set_inputVector_toward_target(1)
	anim.play("jump")
	DAMAGES_ON_CONTACT = true
	pass

func anim_done():
	if anim.animation.get_basename() == "land":
		anim.play("idle")

func land():
	inputVector = Vector2.ZERO
	idle_timer = 0
	land_timer = 0
	anim.play("land")
	DAMAGES_ON_CONTACT = false
