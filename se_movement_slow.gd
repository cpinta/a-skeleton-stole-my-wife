extends StatusEffect
class_name SE_MovementSlow

@export var SLOW_MULTIPLIER: float = 0.8

func _init(entity: Entity, time=TIME_APPLIED, multiplier=SLOW_MULTIPLIER):
	super._init(entity, time)
	statusName = "Slowness"
	description = "this slows you a bit"
	
	SLOW_MULTIPLIER = multiplier
	pass

func apply(delta):
	target.movement_max_speed = target.movement_max_speed * SLOW_MULTIPLIER
	timeLeft -= delta
	return timeLeft
