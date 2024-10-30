extends StatusEffect
class_name SE_Movement_Speed

var ADDITION: float = 1

#SE_Hitstun.new(self, time)
func _init(entity: Entity, time=TIME_APPLIED, addition=ADDITION):
	super._init(entity, time)
	statusName = "Speed Up"
	description = "Up your mile time"
	
	ADDITION = addition
	pass

func apply(delta):
	target.movement_acceleration += ADDITION
	target.movement_max_speed += ADDITION
	return 1

func was_removed():
	super.was_removed()
	pass
