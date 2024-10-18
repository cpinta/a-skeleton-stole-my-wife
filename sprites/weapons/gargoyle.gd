extends Enemy
class_name Gargoyle

enum GargoyleState {FLYING = 0, TURNING_TO_STONE = 1, STONE = 2, POST_STONE = 3, POST_STONE_FLY = 4}

var state: GargoyleState = GargoyleState.FLYING

var FLY_HEIGHT: float = 75

var FLY_BOB_SPEED: float = 50
var currentTimer: float = 0

var FLY_OVERHEAD_TIME: float = 2
var flyOverheadTimer: float = 0
var OVERHEAD_DISTANCE: float = 20

var TRANSFORM_TIME: float = 0.25
var STONE_TIME_BEFORE_FALL: float = 0.5
var STONE_ON_GROUND_TIME: float = 3

var STONE_FALL_SPEED: float = 200

var FLYING_AWAY_DISTANCE: float = 300

var dirVector: Vector2 = Vector2.ZERO

var hitboxArea: Area2D
var hitbox: CollisionShape2D

var escapeVector: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	FOLLOWS_PLAYER = true
	FLIP_TOWARD_PLAYER = true
	USES_DEFAULT_ANIMATIONS = false
	elementHeight.isAffectedByHeight = true
	elementHeight.DOES_HEIGHT_USE_GRAVITY = false
	
	BASE_MOVEMENT_MAX_SPEED = 300
	BASE_MOVEMENT_ACCELERATION = 500
	BASE_ATTACK_KNOCKBACK = 200
	BASE_ATTACK_DURATION = 0.25
	
	#HAS_TURNING_RADIUS = true
	turning_radius = 10
	
	elementHeight.height = FLY_HEIGHT

	anim.play("fly")
	anim.connect("animation_finished", anim_done)
	
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	match state:
		GargoyleState.FLYING:
			anim.play("fly")
			if anim.get_frame() == 0:
				elementHeight.height -= delta * FLY_BOB_SPEED
			else:
				elementHeight.height += delta * FLY_BOB_SPEED
			pass
		GargoyleState.TURNING_TO_STONE:
			anim.play("transform")
			pass
		GargoyleState.STONE:
			anim.play("stone")
			pass
		GargoyleState.POST_STONE:
			pass
		GargoyleState.POST_STONE_FLY:
			anim.play("fly")
			pass
	pass
	
func _physics_process(delta):
	super._physics_process(delta)
	match state:
		GargoyleState.FLYING:
			set_inputVector_toward_target(delta)
			check_direction()
			if global_position.distance_to(target.global_position) < OVERHEAD_DISTANCE:
				if flyOverheadTimer < FLY_OVERHEAD_TIME:
					flyOverheadTimer += delta
				else:
					state = GargoyleState.TURNING_TO_STONE
					pass
			else:
				if flyOverheadTimer > 0:
					flyOverheadTimer -= delta
			pass
		GargoyleState.TURNING_TO_STONE:
			
			pass
		GargoyleState.STONE:
			if currentTimer < STONE_TIME_BEFORE_FALL:
				currentTimer += delta
			else:
				if elementHeight.height > 0:
					elementHeight.height -= delta * STONE_FALL_SPEED
					DAMAGES_ON_CONTACT = true
				else:
					change_state(GargoyleState.POST_STONE)
					
			pass
		GargoyleState.POST_STONE:
			if currentTimer < STONE_ON_GROUND_TIME:
				currentTimer += delta
			else:
				change_state(GargoyleState.POST_STONE_FLY)
				pass
			pass
		GargoyleState.POST_STONE_FLY:
			rb.collision_mask = 0b1001000
			if elementHeight.height < FLY_HEIGHT:
				elementHeight.height += delta * STONE_FALL_SPEED
			inputVector = escapeVector
			if global_position.distance_to(target.global_position) > FLYING_AWAY_DISTANCE:
				queue_free()
			pass
	pass
	
func change_state(newState: GargoyleState):
	currentTimer = 0
	state = newState
	match newState:
		GargoyleState.FLYING:
			FOLLOWS_PLAYER = true
			FLIP_TOWARD_PLAYER = true
			DAMAGES_ON_CONTACT = false
			pass
		GargoyleState.TURNING_TO_STONE:
			FOLLOWS_PLAYER = false
			FLIP_TOWARD_PLAYER = false
			inputVector = Vector2.ZERO
			pass
		GargoyleState.STONE:
			FOLLOWS_PLAYER = false
			FLIP_TOWARD_PLAYER = false
			inputVector = Vector2.ZERO
			pass
		GargoyleState.POST_STONE:
			FOLLOWS_PLAYER = false
			DAMAGES_ON_CONTACT = false
			pass
		GargoyleState.POST_STONE_FLY:
			FOLLOWS_PLAYER = false
			escapeVector = Vector2.RIGHT.rotated(randf_range(0, 2*PI))
			inputVector = escapeVector
			check_direction()
			pass
	pass

func anim_done():
	var animName = anim.animation.get_basename()
	match animName:
		"transform":
			change_state(GargoyleState.STONE)
			pass
		_:
			pass
	pass

func apply_attack_to_entity(entity: Entity):
	attack_statusEffects = [SE_Hitstun.new(entity, attack_duration)]
	super.apply_attack_to_entity(entity)
	

func _on_collider_area_entered(area):
	pass # Replace with function body.
