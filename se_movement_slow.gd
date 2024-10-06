extends StatusEffect
class_name SE_MovementSlow

@export var SLOW_MULTIPLIER: float = 0.8

func _init(time=TIME_APPLIED, multiplier=SLOW_MULTIPLIER):
	super._init(time)
	statusName = "Slowness"
	description = "this slows you a bit"
	
	SLOW_MULTIPLIER = multiplier
	pass

func apply(delta, entity: Entity):
	entity.movement_max_speed = entity.movement_max_speed * SLOW_MULTIPLIER
	timeLeft -= delta
	return timeLeft
